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

# TODO: switch timg to swiv
${TERMINAL} --app-id="$TARGET_APP_ID" -T "fzf-preview" -e bash -c '
PIPE=$1
printf "\e[?1049h\e[?25l"
trap "printf \"\e[?1049l\e[?25h\"" EXIT

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
      timg -C --frames=1 "$line" 
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
      mutool draw -o - "$line" 1 | timg -
      ;;
    *)
      bat --paging=never --style=plain --color=always --line-range :$MAX_LINES "$line" 2>/dev/null 
      ;;
  esac
done <>"$PIPE"
' bash "$PIPE_PATH" >/dev/null 2>&1 &

echo "$PIPE_PATH"
