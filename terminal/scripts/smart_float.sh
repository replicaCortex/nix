#!/usr/bin/env bash

TAKEN_SLOTS=$(niri msg -j windows | jq -r '.[].app_id' | grep -Eo "^float-[1-5]$" || true)

SLOT=5
for i in 3 4 1 2; do
  if [[ ! "$TAKEN_SLOTS" =~ "float-$i" ]]; then
    SLOT=$i
    break
  fi
done

exec footclient --app-id="float-$SLOT" -e "$@"
