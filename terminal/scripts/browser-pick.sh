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

PIPE_PATH=$(${DOTFILES}/terminal/scripts/fzf-preview.sh)

cleanup() {
  if [ -p "$PIPE_PATH" ]; then
    echo "CLOSE_PREVIEW_WINDOW" >"$PIPE_PATH" 2>/dev/null
    rm -f "$PIPE_PATH"
  fi
}
trap cleanup EXIT

IPC_BIND="focus:execute-silent(realpath {} > $PIPE_PATH)"

if [ "$SAVE" = "1" ]; then
  FILENAME=$(basename "${START_PATH}")

  SELECTED_DIR=$(fd --type d | fzf \
    --bind="$IPC_BIND" \
    --prompt="Save in directory: ")

  if [ -z "$SELECTED_DIR" ]; then
    exit 1
  fi

  echo "$(realpath "$SELECTED_DIR")/$FILENAME" >"$OUT_FILE"
  exit 0
fi

if [ "$DIRECTORY" = "1" ]; then
  SELECTED_DIR=$(fd --type d | fzf \
    --bind="$IPC_BIND" \
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

fd --type f | fzf $FZF_OPTS \
  --bind="$IPC_BIND" \
  --prompt="Open files: " | while read -r line; do
  realpath "$line"
done >"$OUT_FILE"
