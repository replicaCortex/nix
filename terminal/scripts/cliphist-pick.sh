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

SELECTED=$(cliphist list | fzf \
  --bind="$IPC_BIND" \
  --prompt="Clipboard: ")

if [ -n "$SELECTED" ]; then
  echo "$SELECTED" | while IFS= read -r line; do
    echo "$line" | cliphist decode
    echo ""
  done | wl-copy
fi
