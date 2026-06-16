#!/usr/bin/env bash

if [ ! -t 0 ]; then
  TAKEN=$(niri msg -j windows | jq -r '.[].app_id' | grep -Eo "^float-[1-5]$" || true)

  if [[ ! "$TAKEN" =~ "float-3" ]] && [[ ! "$TAKEN" =~ "float-4" ]]; then
    PAIR_SLOT="float-3"
  else
    PAIR_SLOT="float-1"
  fi

  exec $WITH_FOCUS footclient --app-id="$PAIR_SLOT" -e "$0" "$@"
fi

PIPE_PATH=$(bash "${DOTFILES}/terminal/scripts/fzf-preview.sh")

cleanup() {
  if [ -p "$PIPE_PATH" ]; then
    echo "CLOSE_PREVIEW_WINDOW" >"$PIPE_PATH" 2>/dev/null
    rm -f "$PIPE_PATH"
  fi
  rm -f "$TMP_PREVIEW"
}
trap cleanup EXIT

TMP_PREVIEW="/tmp/cliphist_preview_$$"
IPC_BIND="focus:execute-silent(echo {} | cliphist decode > $TMP_PREVIEW && echo \"$TMP_PREVIEW\" > $PIPE_PATH)"

OUTPUT=$(cliphist list | fzf \
  --bind="$IPC_BIND" \
  --expect=ctrl-e \
  --header="c-e: collage" \
  --prompt="Clipboard: ")

[[ -z "$OUTPUT" ]] && exit 0

KEY=$(echo "$OUTPUT" | head -n 1)
SELECTED=$(echo "$OUTPUT" | sed '1d')

[[ -z "$SELECTED" ]] && exit 0

COUNT=$(echo "$SELECTED" | grep -c '[^[:space:]]')

if [ "$KEY" = "ctrl-e" ]; then
  declare -a images_to_stitch
  EXPORT_DIR=$(mktemp -d /tmp/cliphist_collage_XXXXXX)

  while IFS= read -r line; do
    [[ -z "$line" ]] && continue

    if echo "$line" | grep -q "\[\[ binary data"; then
      ID=$(echo "$line" | grep -Eo '^[0-9]+')
      FILE_PATH="$EXPORT_DIR/image_${ID}.png"

      echo "$line" | cliphist decode >"$FILE_PATH"
      images_to_stitch+=("$FILE_PATH")
    fi
  done <<<"$SELECTED"

  IMG_COUNT=${#images_to_stitch[@]}

  if [ "$IMG_COUNT" -eq 2 ]; then
    OUT=$(mktemp /tmp/cliphist_side_by_side_XXXXXX.png)
    magick "${images_to_stitch[@]}" \
      -gravity center \
      -background "#282828" \
      +smush 20 \
      -bordercolor "#282828" -border 20 \
      "$OUT"
    wl-copy -t image/png <"$OUT"
    notify-send "Clipboard" "Side-by-Side stitched!"

  elif [ "$IMG_COUNT" -gt 2 ]; then
    OUT=$(mktemp /tmp/cliphist_moodboard_XXXXXX.png)
    montage "${images_to_stitch[@]}" -auto-orient -geometry 800x800\>+10+10 -background gray -tile 3x "$OUT"
    wl-copy -t image/png <"$OUT"
    notify-send "Clipboard" "Grid of $IMG_COUNT images copied!"

  else
    notify-send "Error" "Select 2 or more images for collage"
  fi

  exit 0
fi

if [ "$COUNT" -eq 1 ]; then
  echo "$SELECTED" | cliphist decode | wl-copy
  exit 0
fi

if echo "$SELECTED" | grep -q "\[\[ binary data"; then
  EXPORT_DIR=$(mktemp -d /tmp/cliphist_export_XXXXXX)
  URI_LIST=""

  while IFS= read -r line; do
    [[ -z "$line" ]] && continue

    ID=$(echo "$line" | grep -Eo '^[0-9]+')

    if echo "$line" | grep -q "\[\[ binary data"; then
      if echo "$line" | grep -qi "jpeg\|jpg"; then
        FILE_PATH="$EXPORT_DIR/image_${ID}.jpg"
      else
        FILE_PATH="$EXPORT_DIR/image_${ID}.png"
      fi
    else
      FILE_PATH="$EXPORT_DIR/text_${ID}.txt"
    fi

    echo "$line" | cliphist decode >"$FILE_PATH"
    URI_LIST+="file://${FILE_PATH}\r\n"
  done <<<"$SELECTED"

  echo -e -n "$URI_LIST" | wl-copy -t text/uri-list
  notify-send "Clipboard History" "Copied $COUNT files (ready to paste)"

else
  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    echo "$line" | cliphist decode
    echo ""
  done <<<"$SELECTED" | wl-copy

  notify-send "Clipboard History" "Copied $COUNT text fragments"
fi
