#!/usr/bin/env bash

shopt -s nullglob

[ -f "$ENV_SECRETS" ] && set -a && source "$ENV_SECRETS" && set +a

VAULT_DIR="$HOME/vault"
INBOX_PATH="/tmp/inbox_$$.txt"
PROCESSED_LIST="/tmp/processed_files_$$.txt"
NORMALIZER_DIR="${DOTFILES}/terminal/scripts/normalizers"

for cmd in jq tmsu fd curl sqlite3; do
  command -v "$cmd" >/dev/null 2>&1 || {
    echo >&2 "Error: '$cmd' is required"
    exit 1
  }
done

>"$INBOX_PATH"
>"$PROCESSED_LIST"

PARSER_DIR="${DOTFILES}/terminal/scripts/parsers"
PARSERS=$(fd -e sh . "$PARSER_DIR" 2>/dev/null)

for file in *; do
  if [ -f "$file" ]; then
    existing_tags=$(tmsu --database="${TMSU_DB}" tags "$PWD/$file" | sed -n 's/^.*: //p')
    suggested_tags=""
    file_type=""

    if [[ "$file" == *.* ]]; then
      ext="${file##*.}"
      ext_lower=$(echo "$ext" | tr '[:upper:]' '[:lower:]')
    else
      ext_lower=""
    fi

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
      [[ "$(basename "$parser")" =~ groq ]] && continue

      parser_output=$("$parser" "$file")
      if [ -n "$parser_output" ]; then
        suggested_tags="$suggested_tags $parser_output"

        parser_name=$(basename "$parser" .sh)
        if [ -f "$NORMALIZER_DIR/${parser_name}.sh" ]; then
          file_type="$parser_name"
        fi
      fi
    done

    groq_tags=""
    groq_failed=0

    if [ "$is_book" -eq 1 ] || [ "$is_video" -eq 1 ]; then
      if [ -z "$GROQ_API_KEY" ]; then
        groq_failed=1
      else
        if [ "$is_book" -eq 1 ] && [ -f "${PARSER_DIR}/book-groq.sh" ]; then
          groq_tags=$("${PARSER_DIR}/book-groq.sh" "$file" </dev/null)
          [ -z "$groq_tags" ] && groq_failed=1
          file_type="groq"
        elif [ "$is_video" -eq 1 ] && [ -f "${PARSER_DIR}/video-groq.sh" ]; then
          groq_tags=$("${PARSER_DIR}/video-groq.sh" "$file" </dev/null)
          [ -z "$groq_tags" ] && groq_failed=1
          file_type="groq"
        fi
      fi
    fi

    if [ "$groq_failed" -eq 1 ]; then
      echo "Parsing error for $file"
      continue
    fi

    if [ -n "$groq_tags" ]; then
      suggested_tags="$suggested_tags $groq_tags"
    fi

    if [ "$is_book" -eq 1 ]; then
      [[ ! "$existing_tags $suggested_tags" =~ "author=" ]] && suggested_tags="author=\"\" $suggested_tags"
      [[ ! "$existing_tags $suggested_tags" =~ "year=" ]] && suggested_tags="year=\"\" $suggested_tags"
      [[ ! "$existing_tags $suggested_tags" =~ "title=" ]] && suggested_tags="title=\"\" $suggested_tags"
    fi

    all_tags=$(echo "$existing_tags $suggested_tags" | sed 's/  */ /g' | sed 's/^ //; s/ $//')

    echo "$all_tags | $file | $file_type" >>"$INBOX_PATH"
  fi
done

[ ! -s "$INBOX_PATH" ] && {
  rm -f "$INBOX_PATH" "$PROCESSED_LIST"
  exit 0
}

echo "" >>$INBOX_PATH
printf "# " >>$INBOX_PATH

sqlite3 "${TMSU_DB}" "
  SELECT tag.name 
  FROM tag 
  JOIN file_tag ON tag.id = file_tag.tag_id 
  WHERE tag.name NOT LIKE 'title=%' 
    AND tag.name NOT LIKE 'author=%' 
    AND tag.name NOT LIKE 'year=%'
  GROUP BY tag.id 
  HAVING COUNT(file_tag.file_id) >= 5
  ORDER BY tag.name ASC;
" 2>/dev/null | tr '\n' ' ' >>"$INBOX_PATH"

${EDITOR} "$INBOX_PATH"

while IFS='|' read -r tags filename file_type <&9; do
  [[ "$tags" =~ ^# ]] && continue

  tags=$(echo "$tags" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
  filename=$(echo "$filename" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
  file_type=$(echo "$file_type" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

  [ -z "$filename" ] && continue
  [ ! -f "$filename" ] && continue

  title_val=$(echo "$tags" | grep -o 'title="[^"]*"' | sed 's/title="//; s/"//')
  author_val=$(echo "$tags" | grep -o 'author="[^"]*"' | sed 's/author="//; s/"//')
  year_val=$(echo "$tags" | grep -o 'year="[^"]*"' | sed 's/year="//; s/"//')

  tags=$(echo "$tags" | sed -E 's/title="[^"]*"//g; s/author="[^"]*"//g; s/year="[^"]*"//g')

  if [ -n "$author_val" ]; then
    clean_author=$(echo "$author_val" | sed -E 's/[[:space:]]+/-/g')
    tags="$tags @$clean_author"
  fi

  if [ -n "$year_val" ]; then
    clean_year=$(echo "$year_val" | sed -E 's/[[:space:]]+//g')
    tags="$tags $clean_year"
  fi

  if [ -n "$title_val" ]; then
    base_name="$title_val"
  else
    base_name="${filename%.*}"

    if [ -n "$file_type" ] && [ "$file_type" != "groq" ] && [ -f "$NORMALIZER_DIR/${file_type}.sh" ]; then
      external_title=$("$NORMALIZER_DIR/${file_type}.sh" "$filename")
      if [ -n "$external_title" ]; then
        base_name="$external_title"
      fi
    fi
  fi

  clean_title=$(echo "$base_name" | awk '{print tolower($0)}' | sed 's/[^a-zа-я0-9]/-/g' | sed 's/-\{2,\}/-/g' | sed 's/^-//; s/-$//')

  hash=$(echo -n "$filename" | md5sum | awk '{print $1}' | cut -c 1-6)

  if [[ "$filename" == *.* ]]; then
    ext="${filename##*.}"
    new_filename="${clean_title}-${hash}.${ext}"
  else
    new_filename="${clean_title}-${hash}"
  fi

  existing_active_tags=$(tmsu --database="${TMSU_DB}" tags "$PWD/$filename" | sed -n 's/^.*: //p')
  if [ -n "$existing_active_tags" ]; then
    echo "$existing_active_tags" | xargs tmsu --database="${TMSU_DB}" untag "$PWD/$filename" 2>/dev/null
  fi

  if [ "$filename" != "$new_filename" ]; then
    mv "$filename" "$new_filename"
    tmsu --database="${TMSU_DB}" repair --manual "$PWD/$filename" "$PWD/$new_filename" 2>/dev/null
    current_file="$new_filename"
  else
    current_file="$filename"
  fi

  tags=$(echo "$tags" | sed 's/  */ /g' | sed 's/^ //; s/ $//')

  if [ -n "$tags" ]; then
    echo "$tags" | xargs tmsu --database="${TMSU_DB}" tag "$PWD/$current_file"
  fi

  echo "$current_file" >>"$PROCESSED_LIST"

done 9<"$INBOX_PATH"

POST_PARSER="${DOTFILES}/terminal/scripts/parsers/wd14.py"

if [ -f "$POST_PARSER" ] && [ -s "$PROCESSED_LIST" ]; then
  if command -v ffmpegthumbnailer >/dev/null 2>&1; then
    while read -r file; do
      [ -z "$file" ] && continue
      [ ! -f "$file" ] && continue

      if [[ "$file" == *.* ]]; then
        ext_lower=$(echo "${file##*.}" | tr '[:upper:]' '[:lower:]')
      else
        ext_lower=""
      fi

      case "$ext_lower" in
      mp4 | mkv | avi | mov | webm | flv | wmv | m4v)
        ffmpegthumbnailer -i "$file" -o "${file}.thumb.png" -s 512 -t 10% >/dev/null 2>&1
        ;;
      esac
    done <"$PROCESSED_LIST"
  fi

  uv run "$POST_PARSER" | while IFS='|' read -r filename tags; do
    filename=$(echo "$filename" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    tags=$(echo "$tags" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

    if [ -n "$filename" ] && [ -n "$tags" ] && [ -f "$filename" ]; then
      if [[ "$filename" == *.thumb.png ]]; then
        real_file="${filename%.thumb.png}"
      else
        real_file="$filename"
      fi

      if grep -Fqx "$real_file" "$PROCESSED_LIST" >/dev/null 2>&1; then
        echo "$tags" | xargs tmsu --database="${TMSU_DB}" tag "$PWD/$real_file"
      fi
    fi
  done

  rm -f *.thumb.png 2>/dev/null
fi

if [ -f "$PROCESSED_LIST" ]; then
  while read -r file; do
    [ -z "$file" ] && continue
    [ ! -f "$file" ] && continue

    file_md5=$(head -c 1M "$file" | md5sum | awk '{print $1}')
    dir_prefix="${file_md5:0:2}"

    target_dir="$VAULT_DIR/$dir_prefix"
    mkdir -p "$target_dir"

    if [ -e "$target_dir/$file" ]; then
      new_name="${file%.*}_$(date +%s).${file##*.}"
      mv -n "$file" "$target_dir/$new_name"
      tmsu --database="${TMSU_DB}" repair --manual "$PWD/$file" "$target_dir/$new_name" 2>/dev/null
    else
      mv -n "$file" "$target_dir/$file"
      tmsu --database="${TMSU_DB}" repair --manual "$PWD/$file" "$target_dir/$file" 2>/dev/null
    fi

  done <"$PROCESSED_LIST"
fi

rm -f "$INBOX_PATH" "$PROCESSED_LIST"

tmsu --database="${TMSU_DB}" repair ~/vault/** --remove
sqlite3 "${TMSU_DB}" "DELETE FROM tag WHERE id NOT IN (SELECT DISTINCT tag_id FROM file_tag);"
