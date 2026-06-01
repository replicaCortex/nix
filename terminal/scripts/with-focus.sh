#!/usr/bin/env bash

QUTE_ID=$(niri msg -j windows | jq -r '.[] | select(.is_focused) | .id' 2>/dev/null)

"$@"

STATUS=$?

if [ "$STATUS" -eq 0 ]; then
  if [ -n "$QUTE_ID" ] && [ "$QUTE_ID" != "null" ]; then
    niri msg action focus-window --id "$QUTE_ID"
  fi
fi
