#!/usr/bin/env bash

FILE="/tmp/qute_buffer-${PPID}.txt"

if [ "$1" == "push" ]; then
  TARGET_URL="${2}"

  if [ -n "$TARGET_URL" ]; then
    echo "$TARGET_URL" >>"$FILE"
    notify-send "$TARGET_URL add"
  fi

elif [ "$1" == "pop" ]; then
  if [ -f "$FILE" ]; then
    mv "$FILE" "${FILE}.lock"
    sed 's/^/open -w /' "${FILE}.lock" >>"$QUTE_FIFO"
    notify-send "open $(cat "$FILE.lock" | wc -l) link(s)"
    rm -f "${FILE}.lock"
  fi
fi
