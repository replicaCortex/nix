#!/usr/bin/env bash

PREVIEW_SCRIPT="${DOTFILES}/terminal/scripts/fzf-preview.sh"
PIPE_PATH=$("$PREVIEW_SCRIPT")

cleanup() {
  if [ -p "$PIPE_PATH" ]; then
    echo "CLOSE_PREVIEW_WINDOW" >"$PIPE_PATH" 2>/dev/null
    rm -f "$PIPE_PATH"
  fi
}
trap cleanup EXIT

format_args() {
  local result=""
  for arg in "$@"; do
    result+=" '${arg//\'/\'\\\'\'}'"
  done
  echo "$result"
}

IPC_BIND="focus:execute-silent(bash -c 'f=\"\$1\"; f=\"\${f% : *}\"; realpath \"\$f\" > \"\$2\" 2>/dev/null' _ {} \"$PIPE_PATH\")"
TMSU_DB="$HOME/.tmsu/db"

mapfile -t output < <(
  {
    sqlite3 "$TMSU_DB" "
      SELECT file.directory || '/' || file.name || ' : ' || group_concat(tag.name, ' ') 
      FROM file 
      JOIN file_tag ON file.id = file_tag.file_id 
      JOIN tag ON file_tag.tag_id = tag.id 
      GROUP BY file.id;
    " 2>/dev/null

    fd -t f -E vault
  } | LC_ALL=C sort -u | awk -F ' : ' '{ if(NF==2) print $1 "\033[38;2;146;131;116m : \033[38;2;131;165;152m" $2 "\033[0m"; else print $0 }' | fzf --print-query --expect=ctrl-x --expect=ctrl-r --expect=ctrl-g --expect=ctrl-v --expect=ctrl-a --expect=ctrl-t --expect=ctrl-y --expect=ctrl-d --expect=ctrl-o --bind="$IPC_BIND" \
    --header="c-d: dir | c-y: cVal | c-a: cPath | c-x: rip | c-v: move | c-t: eTags | c-g: aTags | c-r: rName | c-o: oTags"
)

[[ ${#output[@]} -eq 0 ]] && exit 0

query="${output[0]}"
key="${output[1]}"
results=("${output[@]:2}")

[[ -z "$key" && ${#results[@]} -eq 0 ]] && exit 0

PARENT_PROC=$(ps -o comm= -p $PPID 2>/dev/null)
PARENT_PROC="${PARENT_PROC// /}"

case "$PARENT_PROC" in
bash | zsh | sh | fish) SPAWNED_MODE=false ;;
*) SPAWNED_MODE=true ;;
esac

get_abs_path() {
  local p="${1% : *}"
  [[ "$p" != /* ]] && echo "${PWD}/${p}" || echo "$p"
}

if [ "$key" = "ctrl-r" ]; then
  declare -a selected_files
  for result in "${results[@]}"; do
    result=$(get_abs_path "$result")
    [ -e "$result" ] && selected_files+=("$result")
  done

  if [ ${#selected_files[@]} -gt 0 ]; then
    "${DOTFILES}/terminal/scripts/vidir.sh" "${selected_files[@]}"
    notify-send "Vidir" "Rename ${#selected_files[@]} file(s)"
  fi
  exit 0
fi

if [ "$key" = "ctrl-o" ]; then
  declare -a images

  if [ -n "$query" ]; then
    # FIX: dont work
    clean_query="${query// !/ not }"
    [[ "$clean_query" == !* ]] && clean_query="not ${clean_query:1}"

    mapfile -t images < <(
      tmsu --database="${TMSU_DB}" files "$clean_query" 2>/dev/null |
        rg -i '\.(png|jpg|jpeg|webp|tiff|gif)$' |
        awk -v pwd="$PWD" '{ if ($0 !~ /^\//) print pwd "/" $0; else print $0 }'
    )
  fi

  if [ ${#images[@]} -eq 0 ] && [ ${#results[@]} -gt 0 ]; then
    for res in "${results[@]}"; do
      res=$(get_abs_path "$res")
      if [ -f "$res" ]; then
        case "${res##*/}" in
        *.[Pp][Nn][Gg] | *.[Jj][Pp][Gg] | *.[Jj][Pp][Ee][Gg] | *.[Ww][Ee][Bb][Pp] | *.[Tt][Ii][Ff][Ff] | *.[Gg][Ii][Ff])
          images+=("$res")
          ;;
        esac
      fi
    done
  fi

  if [ ${#images[@]} -gt 0 ]; then
    if [ "${SPAWNED_MODE}" = true ]; then
      ${WM_SPAWN} "${IMAGE_VIEWER} $(format_args "${images[@]}")"
    else
      ${IMAGE_VIEWER} "${images[@]}" &
    fi
  else
    notify-send "fzf-open" "No images found for query: $query"
  fi
  exit 0
fi

if [ "$key" = "ctrl-g" ]; then
  for result in "${results[@]}"; do
    result=$(get_abs_path "$result")

    ext="${result##*.}"
    ext_lower="${ext,,}"

    case "$ext_lower" in
    pdf | epub | fb2 | mobi)
      tags=$("${DOTFILES}/terminal/scripts/parsers/book-groq.sh" "$result")
      ;;
    mp4 | mkv | avi | webm)
      tags=$("${DOTFILES}/terminal/scripts/parsers/video-groq.sh" "$result")
      ;;
    esac

    if [ -n "$tags" ]; then
      echo "$tags" | xargs tmsu --database="${TMSU_DB}" tag "$result"
      notify-send "AI Tags" "Tags added for $(basename "$result")"
    fi
  done
  exit 0
fi

if [ "$key" = "ctrl-t" ]; then
  EDIT_TAGS_FILE=$(mktemp /tmp/tmsu_edit_tags_XXXXXX.txt)

  for result in "${results[@]}"; do
    raw_path=$(get_abs_path "$result")

    if [ -f "$raw_path" ]; then
      current_tags=$(tmsu --database="${TMSU_DB}" tags "$raw_path" 2>/dev/null | sed -n 's/^.*: //p')
      echo "$current_tags | $raw_path" >>"$EDIT_TAGS_FILE"
    fi
  done

  if [ -s "$EDIT_TAGS_FILE" ]; then
    ${EDITOR} "$EDIT_TAGS_FILE"

    while IFS='|' read -r tags filepath <&3; do
      tags="${tags#"${tags%%[![:space:]]*}"}"
      tags="${tags%"${tags##*[![:space:]]}"}"
      filepath="${filepath#"${filepath%%[![:space:]]*}"}"
      filepath="${filepath%"${filepath##*[![:space:]]}"}"

      [ -z "$filepath" ] || [ ! -f "$filepath" ] && continue

      existing_active_tags=$(tmsu --database="${TMSU_DB}" tags "$filepath" 2>/dev/null | sed -n 's/^.*: //p')
      if [ -n "$existing_active_tags" ]; then
        echo "$existing_active_tags" | xargs tmsu --database="${TMSU_DB}" untag "$filepath" 2>/dev/null
      fi

      if [ -n "$tags" ]; then
        echo "$tags" | xargs tmsu --database="${TMSU_DB}" tag "$filepath" 2>/dev/null
      fi
    done 3<"$EDIT_TAGS_FILE"

    notify-send "TMSU" "Tags updated"
  fi

  rm -f "$EDIT_TAGS_FILE"
  exit 0
fi

if [ -z "$key" ] || [ "$key" = "enter" ]; then
  declare -a videos images docs others dirs

  for res in "${results[@]}"; do
    res=$(get_abs_path "$res")

    if [ -d "$res" ]; then
      dirs+=("$res")
      continue
    fi

    ext="${res##*.}"
    ext="${ext,,}"

    case "$ext" in
    mkv | mp4 | avi | mov | webm | mp3 | m4a | opus) videos+=("$res") ;;
    png | jpg | jpeg | webp | tiff | gif) images+=("$res") ;;
    pdf | epub | fb2 | mobi | djvu | azw | azw3) docs+=("$res") ;;
    *) others+=("$res") ;;
    esac
  done

  if [ ${#videos[@]} -gt 0 ]; then
    if [ "${SPAWNED_MODE}" = true ]; then
      ${WM_SPAWN} "${VIDEO_VIEWER:-mpv} $(format_args "${videos[@]}")"
    else
      ${VIDEO_VIEWER:-mpv} "${videos[@]}" &
    fi
  fi

  if [ ${#images[@]} -gt 0 ]; then
    if [ "${SPAWNED_MODE}" = true ]; then
      ${WM_SPAWN} "${IMAGE_VIEWER} $(format_args "${images[@]}")"
    else
      ${IMAGE_VIEWER} "${images[@]}" &
    fi
  fi

  if [ ${#docs[@]} -gt 0 ]; then
    if [ "${SPAWNED_MODE}" = true ]; then
      for doc in "${docs[@]}"; do ${WM_SPAWN} "${DOCUMENT_VIEWER} '${doc//\'/\'\\\'\'}'"; done
    else
      for doc in "${docs[@]}"; do ${DOCUMENT_VIEWER} "$doc" & done
    fi
  fi

  if [ ${#others[@]} -gt 0 ]; then
    if [ "${SPAWNED_MODE}" = true ]; then
      for other in "${others[@]}"; do
        ${WM_SPAWN} "${TERMINAL} -e ${EDITOR} $(format_args "${other}")"
      done
    else
      ${EDITOR} "${others[@]}"
    fi
  fi

  if [ ${#dirs[@]} -gt 0 ]; then
    if [ "${SPAWNED_MODE}" = true ]; then
      for d in "${dirs[@]}"; do ${WM_SPAWN} "${TERMINAL} -D '${d//\'/\'\\\'\'}'"; done
    else
      echo "${dirs[0]}" >"/tmp/fzf_cd_${PPID}"
    fi
  fi
  exit 0
fi

declare -a batch_files
paths_to_copy=""

for result in "${results[@]}"; do
  raw_path=$(get_abs_path "$result")

  if [ "$key" = "ctrl-d" ]; then
    [ ! -d "$raw_path" ] && raw_path=$(dirname "$raw_path")
    path_file="${raw_path//\'/\'\\\'\'}"

    if [ "${SPAWNED_MODE}" = true ]; then
      ${WM_SPAWN} "${TERMINAL} -D '${path_file}'"
    else
      echo "$raw_path" >"/tmp/fzf_cd_${PPID}"
      exit 0
    fi
    continue
  fi

  if [ ! -d "$raw_path" ]; then
    batch_files+=("$raw_path")
    paths_to_copy+="$raw_path"$'\n'
  fi
done

if [ ${#batch_files[@]} -gt 0 ]; then
  case "$key" in
  "ctrl-y")
    first_file="${batch_files[0]}"
    file_size=$(stat -c%s "$first_file" 2>/dev/null || stat -f%z "$first_file")
    if [ "$file_size" -lt 10485760 ]; then
      wl-copy <"$first_file"
      notify-send "Copied value" "$(basename "$first_file")"
    else
      notify-send "Error" "File too large"
    fi
    ;;
  "ctrl-a")
    echo -n "$paths_to_copy" | wl-copy
    notify-send "Copied paths" "${#batch_files[@]} file(s)"
    ;;
  "ctrl-v")
    mv -vn "${batch_files[@]}" .
    notify-send "Moved" "${#batch_files[@]} file(s)"
    ;;
  "ctrl-x")
    rip "${batch_files[@]}"
    notify-send "Ripped" "${#batch_files[@]} file(s)"
    ;;
  esac
fi
