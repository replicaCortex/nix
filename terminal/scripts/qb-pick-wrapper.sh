#!/usr/bin/env bash

PICK_SCRIPT="./pick.sh"

SUGGESTED_PATH="$1"
TMP_OUT=$(mktemp)

"$PICK_SCRIPT" "0" "0" "1" "$SUGGESTED_PATH" "$TMP_OUT"

if [ -s "$TMP_OUT" ]; then
  cat "$TMP_OUT"
else
  echo "$SUGGESTED_PATH"
fi

rm -f "$TMP_OUT"
