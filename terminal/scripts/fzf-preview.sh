#!/usr/bin/env bash

CURRENT_APP_ID=$(niri msg -j windows | jq -r '.[] | select(.is_focused) | .app_id' 2>/dev/null)

case "$CURRENT_APP_ID" in
"float-1") TARGET_APP_ID="float-2" ;;
"float-3") TARGET_APP_ID="float-4" ;;
"float-2") TARGET_APP_ID="float-1" ;;
"float-4") TARGET_APP_ID="float-3" ;;
*) TARGET_APP_ID="float-4" ;;
esac

PIPE_PATH="/tmp/fzf-pipe-$RANDOM-$$"
rm -f "$PIPE_PATH"
mkfifo "$PIPE_PATH"

${TERMINAL} --app-id="$TARGET_APP_ID" -T "fzf-preview" -e bash -c '
PIPE=$1
printf "\e[?1049h\e[?25l"
trap "printf \"\e[?1049l\e[?25h\"" EXIT

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/fzf_video_thumbs"
mkdir -p "$CACHE_DIR"

while read -r line; do
  [ "$line" = "CLOSE_PREVIEW_WINDOW" ] && exit 0
  
  clear
  
  if [ -d "$line" ]; then
    eza --tree --level=1 --color=always "$line" 2>/dev/null || ls -p "$line"
    continue
  fi

  TERM_LINES=$(tput lines 2>/dev/null || echo 30)
  MAX_LINES=$((TERM_LINES - 1))

  mime_type=$(file -b --mime-type "$line" 2>/dev/null)
  case "$mime_type" in
    image/*)
      timg -C --frames 1 "$line" 2>/dev/null
      ;;
    video/*)
      HASH=$(echo -n "$line" | md5sum | awk "{print \$1}")
      THUMB_PATH="$CACHE_DIR/${HASH}.jpg"

      if [ ! -f "$THUMB_PATH" ]; then
        if command -v ffmpegthumbnailer >/dev/null 2>&1; then
          ffmpegthumbnailer -i "$line" -o "$THUMB_PATH" -s 512 -c jpeg -q 5 -t 10% 2>/dev/null
        elif command -v ffmpeg >/dev/null 2>&1; then
          ffmpeg -y -loglevel error -ss 00:00:05 -i "$line" -vframes 1 -q:v 5 "$THUMB_PATH" 2>/dev/null
        fi
      fi

      if [ -f "$THUMB_PATH" ]; then
        timg -C --frames 1 "$THUMB_PATH" 2>/dev/null
      else
         echo "Failed to generate video preview."
         echo "Make sure ffmpegthumbnailer or ffmpeg is installed."
      fi
      ;;
    */zip)
      unzip -l "$line"
      ;;
    */gzip)
      gzip -l "$line"
      ;;
    */zstd)
      zstd -l "$line"
      ;;
    */pdf)
      mutool draw -o - "$line" 1 2>/dev/null | timg -C - 2>/dev/null
      ;;
    *)
      bat --paging=never --style=plain --color=always --line-range :$MAX_LINES "$line" 2>/dev/null 
      ;;
  esac
done <>"$PIPE"
' bash "$PIPE_PATH" >/dev/null 2>&1 &

echo "$PIPE_PATH"
