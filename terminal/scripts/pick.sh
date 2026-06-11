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

    fd -t f | rg -v vault
  } | sort -u | awk -F ' : ' '{ if(NF==2) print $1 "\033[38;2;146;131;116m : \033[38;2;131;165;152m" $2 "\033[0m"; else print $0 }' | fzf -m --expect=ctrl-x --expect=ctrl-r --expect=ctrl-g --expect=ctrl-v --expect=ctrl-a --expect=ctrl-t --expect=ctrl-y --expect=ctrl-d --bind="$IPC_BIND" \
    --header="c-d: dir | c-y: cVal | c-a: cPath | c-x: rip | c-v: move | c-t: eTags | c-g: aTags | c-r: rName"
)

[[ ${#output[@]} -eq 0 ]] && exit 0

key="${output[0]}"
results=("${output[@]:1}")

[[ ${#results[@]} -eq 0 || -z "${results[0]}" ]] && exit 0

PARENT_PROC=$(ps -o comm= -p $PPID 2>/dev/null | tr -d ' ')
case "$PARENT_PROC" in
bash | zsh | sh | fish) SPAWNED_MODE=false ;;
*) SPAWNED_MODE=true ;;
esac

if [ "$key" = "ctrl-r" ]; then
  declare -a selected_files
  for result in "${results[@]}"; do
    result="${result% : *}"
    [[ "$result" != /* ]] && result="${PWD}/${result}"
    [ -e "$result" ] && selected_files+=("$result")
  done

  if [ ${#selected_files[@]} -gt 0 ]; then
    ${DOTFILES}/terminal/scripts/vidir.sh "${selected_files[@]}"
    notify-send "Vidir" "Rename ${#selected_files[@]} file(s)"
  fi
  exit 0
fi

if [ "$key" = "ctrl-g" ]; then
  for result in "${results[@]}"; do
    result="${result% : *}"
    [[ "$result" != /* ]] && result="${PWD}/${result}"

    ext_lower=$(echo "${result##*.}" | tr '[:upper:]' '[:lower:]')

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
  EDIT_TAGS_FILE="/tmp/tmsu_edit_tags_$$.txt"
  >"$EDIT_TAGS_FILE"

  for result in "${results[@]}"; do
    result="${result% : *}"
    if [[ "$result" == /* ]]; then
      raw_path="$result"
    else
      raw_path="${PWD}/${result}"
    fi

    if [ -f "$raw_path" ]; then
      current_tags=$(tmsu --database="${TMSU_DB}" tags "$raw_path" 2>/dev/null | sed -n 's/^.*: //p')
      echo "$current_tags | $raw_path" >>"$EDIT_TAGS_FILE"
    fi
  done

  if [ -s "$EDIT_TAGS_FILE" ]; then
    ${EDITOR} "$EDIT_TAGS_FILE"

    while IFS='|' read -r tags filepath <&3; do
      tags=$(echo "$tags" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
      filepath=$(echo "$filepath" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

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
    res="${res% : *}"
    [[ "$res" != /* ]] && res="${PWD}/${res}"

    if [ -d "$res" ]; then
      dirs+=("$res")
      continue
    fi

    ext=$(echo "${res##*.}" | tr '[:upper:]' '[:lower:]')
    case "$ext" in
    mkv | mp4 | avi | mov | webm | mp3 | m4a | opus)
      videos+=("$res")
      ;;
    png | jpg | jpeg | webp | tiff | gif)
      images+=("$res")
      ;;
    pdf | epub | fb2 | mobi | djvu | azw | azw3)
      docs+=("$res")
      ;;
    *)
      others+=("$res")
      ;;
    esac
  done

  format_args() {
    local result=""
    for arg in "$@"; do
      result+=" '${arg//\'/\'\\\'\'}'"
    done
    echo "$result"
  }

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
      for doc in "${docs[@]}"; do
        ${WM_SPAWN} "${DOCUMENT_VIEWER} '${doc//\'/\'\\\'\'}'"
      done
    else
      for doc in "${docs[@]}"; do
        ${DOCUMENT_VIEWER} "$doc" &
      done
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
      for d in "${dirs[@]}"; do
        ${WM_SPAWN} "${TERMINAL} -D '${d//\'/\'\\\'\'}'"
      done
    else
      echo "${dirs[0]}" >"/tmp/fzf_cd_${PPID}"
    fi
  fi

  exit 0
fi

for result in "${results[@]}"; do
  result="${result% : *}"

  if [[ "$result" == /* ]]; then
    raw_path="$result"
  else
    raw_path="${PWD}/${result}"
  fi
  path_file="${raw_path//\'/\'\\\'\'}"

  if [ "$key" = "ctrl-d" ]; then
    if [ ! -d "$raw_path" ]; then
      raw_path=$(dirname "$raw_path")
      path_file="${raw_path//\'/\'\\\'\'}"
    fi
    if [ "${SPAWNED_MODE}" = true ]; then
      ${WM_SPAWN} "${TERMINAL} -D '${path_file}'"
    else
      echo "$raw_path" >"/tmp/fzf_cd_${PPID}"
      exit 0
    fi
    continue
  fi

  if [ "$key" = "ctrl-y" ]; then
    if [ ! -d "$raw_path" ]; then
      file_size=$(stat -c%s "$raw_path" 2>/dev/null || stat -f%z "$raw_path")
      if [ "$file_size" -lt 10485760 ]; then
        wl-copy <"$raw_path"
        notify-send "Copied value" "$(basename "$raw_path")"
      else
        notify-send "Error" "File too large"
      fi
    fi
    continue
  fi

  if [ "$key" = "ctrl-a" ]; then
    if [ ! -d "$raw_path" ]; then
      echo "$raw_path" | wl-copy
      notify-send "Copied path" "$(basename "$raw_path")"
    fi
    continue
  fi

  if [ "$key" = "ctrl-v" ]; then
    if [ ! -d "$raw_path" ]; then
      mv -vn "$raw_path" .
      notify-send "Moved" "$(basename "$raw_path")"
    fi
    continue
  fi

  if [ "$key" = "ctrl-x" ]; then
    if [ ! -d "$raw_path" ]; then
      rip "$raw_path"
      notify-send "Ripped" "$(basename "$raw_path")"
    fi
    continue
  fi

done
