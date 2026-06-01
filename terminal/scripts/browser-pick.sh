#!/usr/bin/env bash

if [ ! -t 0 ]; then
  exec $WITH_FOCUS $SMART_FLOAT "$0" "$@"
fi

MULTIPLE="$1"
DIRECTORY="$2"
SAVE="$3"
# START_PATH="$4"
OUT_FILE="$5"

if [ -d "$START_PATH" ]; then
  cd "$START_PATH" || exit 1
elif [ -f "$START_PATH" ]; then
  cd "$(dirname "$START_PATH")" || exit 1
else
  cd "$HOME" || exit 1
fi

EZA="eza --tree --level=1 --color=always {} 2>/dev/null {}"

if [ "$SAVE" = "1" ]; then
  FILENAME=$(basename "${START_PATH:-saved_file}")

  SELECTED_DIR=$(fd --type d | fzf \
    --preview="$EZA" \
    --prompt="Save in directory: ")

  if [ -z "$SELECTED_DIR" ]; then
    exit 1
  fi

  echo "$(realpath "$SELECTED_DIR")/$FILENAME" >"$OUT_FILE"
  exit 0
fi

if [ "$DIRECTORY" = "1" ]; then
  SELECTED_DIR=$(fd --type d | fzf \
    --preview="$EZA" \
    --prompt="Selected directory: ")

  if [ -z "$SELECTED_DIR" ]; then
    exit 1
  fi

  realpath "$SELECTED_DIR" >"$OUT_FILE"
  exit 0
fi

FZF_OPTS=""
if [ "$MULTIPLE" = "0" ]; then
  FZF_OPTS="+m"
fi

# INFO: fish :)
PREVIEW_CMD="
if test -d {}
    eza --tree --level=1 --color=always {} 2>/dev/null; or ls -p {}
else if string match -qr '\.(jpg|jpeg|png|gif|bmp|webp|svg|tiff|ico)$' {}
    chafa '{}' 2>/dev/null;
else
    bat --style=plain --color=always --line-range :10 {} 2>/dev/null; or head -n 10 {}
end
echo ""
file -b {}
"

fd --type f | fzf $FZF_OPTS --preview="$PREVIEW_CMD" --preview-window=right:50%:wrap --prompt="Open files: " | while read -r line; do
  realpath "$line"
done >"$OUT_FILE"
