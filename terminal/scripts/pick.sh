#!/usr/bin/env bash

mapfile -t output < <(fd | fzf --expect=ctrl-d)

[[ ${#output[@]} -eq 0 ]] && exit 0

key="${output[0]}"

results=("${output[@]:1}")

[[ ${#results[@]} -eq 0 || -z "${results[0]}" ]] && exit 0

for result in "${results[@]}"; do

  if [ "$key" = "ctrl-d" ]; then
    if [ ! -d "$result" ]; then
      result=$(dirname "$result")
    fi
  fi

  raw_path="${PWD}/${result}"
  path_file="${raw_path//\'/\'\\\'\'}"

  if [ -d "$result" ]; then
    ${WM_SPAWN} "${TERMINAL} -D '${path_file}'"
    continue
  fi

  extension="${result##*.}"
  extension=$(echo "$extension" | tr '[:upper:]' '[:lower:]')

  case "${extension}" in
  mkv | mp4 | avi | webm)
    ${WM_SPAWN} "${VIDEO_VIEWER} '${path_file}'"
    ;;
  mp3 | m4a | opus)
    ${WM_SPAWN} "${TERMINAL} -e ${VIDEO_VIEWER} '${path_file}'"
    ;;
  pdf | djvu | fb2 | cbz)
    ${WM_SPAWN} "${DOCUMENT_VIEWER} '${path_file}'"
    ;;
  png | jpg | jpeg | webp | tiff | gif)
    ${WM_SPAWN} "${VIDEO_VIEWER} '${path_file}'"
    ;;
  *)
    ${WM_SPAWN} "${TERMINAL} -e ${EDITOR} '$path_file'"
    ;;
  esac
done
