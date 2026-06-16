#!/usr/bin/env bash

shopt -s nullglob extglob
set -o pipefail

[ -f "$ENV_SECRETS" ] && set -a && source "$ENV_SECRETS" && set +a

: "${TMSU_DB:?Critical error: TMSU_DB environment variable not set!}"
: "${DOTFILES:?Critical error: DOTFILES environment variable not set!}"
: "${EDITOR:?Critical error: EDITOR environment variable not set!}"

VAULT_DIR="$HOME/vault"
NORMALIZER_DIR="${DOTFILES}/terminal/scripts/normalizers"
PARSER_DIR="${DOTFILES}/terminal/scripts/parsers"

for cmd in jq tmsu fd curl sqlite3 awk md5sum; do
  command -v "$cmd" >/dev/null 2>&1 || {
    echo >&2 "Error: base utility '$cmd' is not installed or not in PATH."
    exit 1
  }
done

INBOX_PATH=$(mktemp /tmp/inbox_XXXXXX.txt)
PROCESSED_LIST=$(mktemp /tmp/processed_files_XXXXXX.txt)

trap 'rm -f "$INBOX_PATH" "$PROCESSED_LIST"' EXIT

PARSERS=$(fd -e sh . "$PARSER_DIR" 2>/dev/null)

for file in *; do
  [ ! -f "$file" ] && continue

  existing_tags=$(tmsu --database="${TMSU_DB}" tags "$PWD/$file" | sed -n 's/^.*: //p')
  suggested_tags=""
  file_type=""

  ext="${file##*.}"
  [[ "$file" == *.* ]] && ext_lower="${ext,,}" || ext_lower=""

  is_book=0
  is_video=0

  case "$ext_lower" in
  pdf | epub | fb2 | mobi | djvu | azw | azw3)
    is_book=1
    file_type="book"
    ;;
  mp4 | mkv | avi | mov | webm | flv | wmv | m4v)
    is_video=1
    file_type="video"
    ;;
  png | jpg | jpeg | webp | tiff | gif)
    is_video=0
    file_type="image"
    ;;
  esac

  for parser in $PARSERS; do
    [[ "${parser##*/}" =~ groq ]] && continue

    parser_output=$("$parser" "$file")
    if [ -n "$parser_output" ]; then
      suggested_tags="$suggested_tags $parser_output"
      parser_name=$(basename "$parser" .sh)
      [ -f "$NORMALIZER_DIR/${parser_name}.sh" ] && file_type="$parser_name"
    fi
  done

  groq_tags=""
  groq_failed=0

  if [ "$is_book" -eq 1 ] || [ "$is_video" -eq 1 ]; then
    if [ -z "$GROQ_API_KEY" ]; then
      groq_failed=1
    else
      if [ "$is_book" -eq 1 ] && [ -f "${PARSER_DIR}/book-groq.sh" ]; then
        if groq_output=$("${PARSER_DIR}/book-groq.sh" "$file" </dev/null); then
          groq_tags=$(echo "$groq_output" | tr '\n' ' ')
          [ -z "$groq_tags" ] && groq_failed=1
          file_type="groq"
        else
          groq_failed=1
        fi
      elif [ "$is_video" -eq 1 ] && [ -f "${PARSER_DIR}/video-groq.sh" ]; then
        if groq_output=$("${PARSER_DIR}/video-groq.sh" "$file" </dev/null); then
          groq_tags=$(echo "$groq_output" | tr '\n' ' ')
          [ -z "$groq_tags" ] && groq_failed=1
          file_type="groq"
        else
          groq_failed=1
        fi
      fi
    fi
  fi

  if [ "$groq_failed" -eq 1 ]; then
    echo "Parser error for $file (skipped)"
    continue
  fi

  [ -n "$groq_tags" ] && suggested_tags="$suggested_tags $groq_tags"

  if [ "$is_book" -eq 1 ]; then
    [[ ! "$existing_tags $suggested_tags" =~ "author=" ]] && suggested_tags="author=\"\" $suggested_tags"
    [[ ! "$existing_tags $suggested_tags" =~ "year=" ]] && suggested_tags="year=\"\" $suggested_tags"
    [[ ! "$existing_tags $suggested_tags" =~ "title=" ]] && suggested_tags="title=\"\" $suggested_tags"
  fi

  all_tags="$existing_tags $suggested_tags"

  all_tags="${all_tags//+([[:space:]])/ }"
  all_tags="${all_tags##+([[:space:]])}"
  all_tags="${all_tags%%+([[:space:]])}"

  echo "${all_tags} ::: ${file} ::: ${file_type}" >>"$INBOX_PATH"
done

[ ! -s "$INBOX_PATH" ] && exit 0

echo -e "\n# Common tag hints:" >>"$INBOX_PATH"
sqlite3 "${TMSU_DB}" "
  SELECT tag.name FROM tag JOIN file_tag ON tag.id = file_tag.tag_id 
  WHERE tag.name NOT LIKE 'title=%' AND tag.name NOT LIKE 'author=%' AND tag.name NOT LIKE 'year=%'
  GROUP BY tag.id HAVING COUNT(file_tag.file_id) >= 5 ORDER BY tag.name ASC;
" 2>/dev/null | tr '\n' ' ' | sed 's/^/# /' >>"$INBOX_PATH"

${EDITOR} "$INBOX_PATH"

while IFS= read -r line <&9; do
  [[ -z "$line" || "$line" =~ ^# ]] && continue

  file_type="${line##* ::: }"
  rest="${line% ::: *}"
  filename="${rest##* ::: }"
  tags="${rest% ::: *}"

  tags="${tags##+([[:space:]])}"
  tags="${tags%%+([[:space:]])}"
  filename="${filename##+([[:space:]])}"
  filename="${filename%%+([[:space:]])}"
  file_type="${file_type##+([[:space:]])}"
  file_type="${file_type%%+([[:space:]])}"

  if [ -z "$filename" ] || [ ! -f "$filename" ]; then
    echo "File '$filename' not found or removed from list. Skipping."
    continue
  fi

  title_val="" author_val="" year_val=""

  [[ "$tags" =~ title=\"([^\"]*)\" ]] && title_val="${BASH_REMATCH[1]}"
  [[ "$tags" =~ author=\"([^\"]*)\" ]] && author_val="${BASH_REMATCH[1]}"
  [[ "$tags" =~ year=\"([^\"]*)\" ]] && year_val="${BASH_REMATCH[1]}"

  tags=$(sed -E 's/(title|author|year)="[^"]*"//g' <<<"$tags")

  if [ -n "$author_val" ]; then
    clean_author="${author_val// /-}"
    tags="$tags @$clean_author"
  fi

  if [ -n "$year_val" ]; then
    clean_year="${year_val// /}"
    tags="$tags $clean_year"
  fi

  if [ -n "$title_val" ]; then
    base_name="$title_val"
  else
    base_name="${filename%.*}"
    if [ -n "$file_type" ] && [ "$file_type" != "groq" ] && [ -f "$NORMALIZER_DIR/${file_type}.sh" ]; then
      external_title=$("$NORMALIZER_DIR/${file_type}.sh" "$filename")
      [ -n "$external_title" ] && base_name="$external_title"
    fi
  fi

  clean_title="${base_name,,}"
  clean_title=$(echo "$clean_title" | sed 's/[^a-zа-яё0-9]/-/g; s/-\{2,\}/-/g; s/^-//; s/-$//')

  hash=$(echo -n "$filename" | md5sum | awk '{print $1}' | cut -c 1-6)

  [[ "$filename" == *.* ]] && new_filename="${clean_title}-${hash}.${filename##*.}" || new_filename="${clean_title}-${hash}"

  existing_active_tags=$(tmsu --database="${TMSU_DB}" tags "$PWD/$filename" | sed -n 's/^.*: //p')
  if [ -n "$existing_active_tags" ]; then
    echo "$existing_active_tags" | xargs tmsu --database="${TMSU_DB}" untag "$PWD/$filename" 2>/dev/null
  fi

  if [ "$filename" != "$new_filename" ]; then
    if [ -e "$new_filename" ]; then
      if [[ "$filename" == *.* ]]; then
        new_filename="${clean_title}-${hash}-$(date +%s).${filename##*.}"
      else
        new_filename="${clean_title}-${hash}-$(date +%s)"
      fi
    fi
    mv -n "$filename" "$new_filename"
    tmsu --database="${TMSU_DB}" repair --manual "$PWD/$filename" "$PWD/$new_filename" 2>/dev/null
    current_file="$new_filename"
  else
    current_file="$filename"
  fi

  tags="${tags//+([[:space:]])/ }"
  tags="${tags##+([[:space:]])}"
  tags="${tags%%+([[:space:]])}"

  if [ -n "$tags" ]; then
    echo "$tags" | xargs tmsu --database="${TMSU_DB}" tag "$PWD/$current_file"
  fi

  echo "$current_file" >>"$PROCESSED_LIST"

done 9<"$INBOX_PATH"

POST_PARSER="${DOTFILES}/terminal/scripts/parsers/wd14.py"

if command -v uv >/dev/null 2>&1 && [ -f "$POST_PARSER" ] && [ -s "$PROCESSED_LIST" ]; then
  if command -v ffmpegthumbnailer >/dev/null 2>&1; then
    while read -r file; do
      [ -z "$file" ] || [ ! -f "$file" ] && continue
      [[ "$file" == *.* ]] && ext_lower="${file##*.}" && ext_lower="${ext_lower,,}" || ext_lower=""

      case "$ext_lower" in
      mp4 | mkv | avi | mov | webm | flv | wmv | m4v)
        ffmpegthumbnailer -i "$file" -o "${file}.thumb.png" -s 512 -t 10% >/dev/null 2>&1
        ;;
      esac
    done <"$PROCESSED_LIST"
  fi

  xargs -r -a "$PROCESSED_LIST" uv run "$POST_PARSER" | while IFS='|' read -r filename tags; do
    filename="${filename##+([[:space:]])}"
    filename="${filename%%+([[:space:]])}"
    tags="${tags##+([[:space:]])}"
    tags="${tags%%+([[:space:]])}"

    if [ -n "$filename" ] && [ -n "$tags" ] && [ -f "$filename" ]; then
      [[ "$filename" == *.thumb.png ]] && real_file="${filename%.thumb.png}" || real_file="$filename"

      if grep -Fqx "$real_file" "$PROCESSED_LIST" >/dev/null 2>&1; then
        echo "$tags" | xargs tmsu --database="${TMSU_DB}" tag "$PWD/$real_file"
      fi
    fi
  done
  rm -f *.thumb.png 2>/dev/null
fi

if [ -s "$PROCESSED_LIST" ]; then
  while read -r file; do
    [ -z "$file" ] || [ ! -f "$file" ] && continue

    file_md5=$({
      head -c 1M "$file"
      stat -c "%s" "$file" 2>/dev/null || stat -f "%z" "$file"
    } | md5sum | awk '{print $1}')
    dir_prefix="${file_md5:0:2}"

    target_dir="$VAULT_DIR/$dir_prefix"
    mkdir -p "$target_dir"

    if [ -e "$target_dir/$file" ]; then
      if [[ "$file" == *.* ]]; then
        new_name="${file%.*}_$(date +%s).${file##*.}"
      else
        new_name="${file}_$(date +%s)"
      fi
      mv -n "$file" "$target_dir/$new_name"
      tmsu --database="${TMSU_DB}" repair --manual "$PWD/$file" "$target_dir/$new_name" 2>/dev/null
    else
      mv -n "$file" "$target_dir/$file"
      tmsu --database="${TMSU_DB}" repair --manual "$PWD/$file" "$target_dir/$file" 2>/dev/null
    fi
  done <"$PROCESSED_LIST"
fi

tmsu --database="${TMSU_DB}" repair --remove
