#!/usr/bin/env bash

CHOICE_AREA="Area"
CHOICE_WINDOW="Column"
CHOICE_SCREEN="Window"
CHOICE_CLIP_FOCUS="Focus"
CHOICE_CLIP_BLUR="Blur"
CHOICE_CLIP_PIXEL="Pixelate"

selected=$(printf "%s\n%s\n%s\n%s\n%s\n%s" \
  "$CHOICE_AREA" "$CHOICE_SCREEN" "$CHOICE_WINDOW" "$CHOICE_CLIP_FOCUS" "$CHOICE_CLIP_BLUR" "$CHOICE_CLIP_PIXEL" |
  fzf --prompt="Action: ")

[ -z "$selected" ] && exit 0

niri-pocus() {
  niri msg action move-column-to-workspace-up
  niri msg action toggle-window-floating
  niri msg action focus-workspace-down
  sleep 0.3
}

edit_clipboard() {
  local effect=$1
  local clip_img pad_img
  clip_img=$(mktemp --suffix=.png)
  pad_img=$(mktemp --suffix=.png)

  niri-pocus

  wl-paste -t image/png >"$clip_img"
  if [ ! -s "$clip_img" ]; then
    notify-send -u critical "Error" "No image in clipboard!" -t 2000
    rm -f "$clip_img" "$pad_img"
    exit 1
  fi

  local ORIG_W ORIG_H
  ORIG_W=$(magick identify -format "%w" "$clip_img")
  ORIG_H=$(magick identify -format "%h" "$clip_img")

  magick "$clip_img" -gravity center -background none -extent 1920x1080 "$pad_img"

  trap 'kill $NSXIV_PID 2>/dev/null; rm -f "$clip_img" "$pad_img"' EXIT

  imv -f "$pad_img" &
  local NSXIV_PID=$!

  local GEOM
  GEOM=$(slurp -b "#00000040" -c "#ff0000" -w 2 -f "%wx%h+%x+%y")

  kill "$NSXIV_PID" 2>/dev/null

  if [ -z "$GEOM" ]; then
    exit 0
  fi

  if [ "$effect" = "focus" ]; then
    magick "$pad_img" \
      \( +clone -fill black -colorize 60% \) -composite \
      \( "$pad_img" -crop "$GEOM" +repage \) \
      -geometry "+${GEOM#*+}" -composite \
      -gravity center -crop "${ORIG_W}x${ORIG_H}+0+0" +repage PNG:- | wl-copy -t image/png

  elif [ "$effect" = "blur" ]; then
    magick "$pad_img" \
      \( "$pad_img" -crop "$GEOM" +repage -blur 0x15 \) \
      -geometry "+${GEOM#*+}" -composite \
      -gravity center -crop "${ORIG_W}x${ORIG_H}+0+0" +repage PNG:- | wl-copy -t image/png

  elif [ "$effect" = "pixelate" ]; then
    magick "$pad_img" \
      \( "$pad_img" -crop "$GEOM" +repage -scale 10% -scale 1000% \) \
      -geometry "+${GEOM#*+}" -composite \
      -gravity center -crop "${ORIG_W}x${ORIG_H}+0+0" +repage PNG:- | tee "$OUT_FILE" | wl-copy -t image/png
  fi

  trap - EXIT
  rm -f "$clip_img" "$pad_img"

  notify-send "Screenshot Edited" "Saved to disk and copied to clipboard!"
}

case "$selected" in
"$CHOICE_AREA")
  niri-pocus
  niri msg action screenshot
  ;;
"$CHOICE_SCREEN")
  niri-pocus
  niri msg action screenshot-screen
  ;;
"$CHOICE_WINDOW")
  niri-pocus
  niri msg action screenshot-window
  ;;
"$CHOICE_CLIP_FOCUS")
  edit_clipboard "focus"
  ;;
"$CHOICE_CLIP_BLUR")
  edit_clipboard "blur"
  ;;
"$CHOICE_CLIP_PIXEL")
  edit_clipboard "pixelate"
  ;;
esac

exit 0
