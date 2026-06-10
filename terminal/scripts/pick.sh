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

# TODO: add rg
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
  } | sort -u | awk -F ' : ' '{ if(NF==2) print $1 "\033[38;2;146;131;116m : \033[38;2;131;165;152m" $2 "\033[0m"; else print $0 }' | fzf --expect=ctrl-x --expect=ctrl-t --expect=ctrl-y --expect=ctrl-d --bind="$IPC_BIND" \
    --header="c-d: dir | c-y: ccon. | c-t: cpath | c-x: rip"
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

for result in "${results[@]}"; do

  result="${result% : *}"

  if [ "$key" = "ctrl-d" ]; then
    if [ ! -d "$result" ]; then
      result=$(dirname "$result")
    fi
  fi

  raw_path="${PWD}/${result}"
  path_file="${raw_path//\'/\'\\\'\'}"

  if [ "$key" = "ctrl-y" ]; then
    if [ ! -d "$raw_path" ]; then
      file_size=$(stat -c%s "$raw_path" 2>/dev/null || stat -f%z "$raw_path")
      if [ "$file_size" -lt 10485760 ]; then
        wl-copy <"$raw_path"
        notify-send "Copy value"
      else
        notify-send "Error"
      fi
      exit 0
    fi
  fi

  if [ "$key" = "ctrl-t" ]; then
    if [ ! -d "$path_file" ]; then
      echo "$path_file" | wl-copy
      notify-send "Copy path"
      exit 0
    fi
  fi

  if [ "$key" = "ctrl-x" ]; then
    if [ ! -d "$path_file" ]; then
      rip "$path_file"
      notify-send "rip $(basename $path_file)"
      exit 0
    fi
  fi

  if [ -d "$raw_path" ]; then
    if [ "${SPAWNED_MODE}" = true ]; then
      ${WM_SPAWN} "${TERMINAL} -D '${path_file}'"
    else
      echo "$raw_path" >"/tmp/fzf_cd_${PPID}"
      exit 0
    fi
    continue
  fi

  extension="${result##*.}"
  extension=$(echo "$extension" | tr '[:upper:]' '[:lower:]')

  case "${extension}" in
  mkv | mp4 | avi | webm)
    if [ "${SPAWNED_MODE}" = true ]; then
      ${WM_SPAWN} "${VIDEO_VIEWER} '${path_file}'"
    else
      ${VIDEO_VIEWER} "${path_file}"
    fi
    ;;
  mp3 | m4a | opus)
    if [ "${SPAWNED_MODE}" = true ]; then
      ${WM_SPAWN} "${TERMINAL} -e ${VIDEO_VIEWER} '${path_file}'"
    else
      ${VIDEO_VIEWER} "${path_file}"
    fi
    ;;
  pdf | epub | fb2 | mobi | djvu | azw | azw3)
    if [ "${SPAWNED_MODE}" = true ]; then
      ${WM_SPAWN} "${DOCUMENT_VIEWER} '${path_file}'"
    else
      ${DOCUMENT_VIEWER} "${path_file}"
    fi
    ;;
  png | jpg | jpeg | webp | tiff | gif)
    if [ "${SPAWNED_MODE}" = true ]; then
      ${WM_SPAWN} "${VIDEO_VIEWER} '${path_file}'"
    else
      # ${VIDEO_VIEWER} "${path_file}"
      timg "${path_file}"
    fi
    ;;
  *)
    if [ "${SPAWNED_MODE}" = true ]; then
      ${WM_SPAWN} "${TERMINAL} -e ${EDITOR} '$path_file'"
    else
      ${EDITOR} "${path_file}"
    fi
    ;;
  esac
done
