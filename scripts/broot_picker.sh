#!/usr/bin/env bash

if [ ! -t 0 ]; then
  TERMCMD="footclient --app-id=float"
  exec $TERMCMD "$0" "$@"
fi

MULTIPLE=$1
DIRECTORY=$2
SAVE=$3
INPUT_PATH="$4"
OUT_FILE="$5"

BROOT_BIN="/run/current-system/sw/bin/broot"
MAIN_CONF="$HOME/.config/broot/conf.hjson"
SELECT_CONF="$HOME/.config/broot/select.hjson"
CONF_FILE="$SELECT_CONF;$MAIN_CONF"

START_DIR="$HOME"

args=(
  "--conf" "$CONF_FILE"
  "--color" "yes"
)

if [ "$SAVE" = "1" ]; then
  FILENAME=$(basename "${INPUT_PATH:-saved_file}")

  args+=("--only-folders")

  SELECTED_DIR=$("$BROOT_BIN" "${args[@]}" "$START_DIR")

  if [ -z "$SELECTED_DIR" ]; then
    exit 1
  fi

  echo "$SELECTED_DIR/$FILENAME" >"$OUT_FILE"
  exit 0
fi

if [ "$DIRECTORY" = "1" ]; then
  args+=("--only-folders")
fi

"$BROOT_BIN" "${args[@]}" "$START_DIR" >"$OUT_FILE"
