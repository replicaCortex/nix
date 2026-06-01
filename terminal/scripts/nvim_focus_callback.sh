#!/usr/bin/env bash

QUTE_ID=$(niri msg -j windows | jq -r '.[] | select(.is_focused) | .id')

$SMART_FLOAT nvim "$@"

if [ -n "$QUTE_ID" ] && [ "$QUTE_ID" != "null" ]; then
  niri msg action focus-window --id "$QUTE_ID"
fi
