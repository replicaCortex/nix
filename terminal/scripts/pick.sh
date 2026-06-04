#!/usr/bin/env bash

mapfile -t output < <(fd | fzf --expect=ctrl-d)

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

  if [ "$key" = "ctrl-d" ]; then
    if [ ! -d "$result" ]; then
      result=$(dirname "$result")
    fi
  fi

  raw_path="${PWD}/${result}"
  path_file="${raw_path//\'/\'\\\'\'}"

  if [ -d "$result" ]; then
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
  pdf | djvu | fb2 | cbz)
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
