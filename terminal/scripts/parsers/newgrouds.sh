#!/usr/bin/env bash

file="$1"

if [[ "$file" =~ ^[0-9]+_[0-9]+_([^_]+)_ ]]; then
  artist="${BASH_REMATCH[1]}"
  echo "@$artist"

# INFO: gallery-dl
elif [[ "$file" =~ ^newgrounds_[0-9]+_([0-9]+_)?([^_]+)_ ]]; then
  artist="${BASH_REMATCH[2]}"
  echo "@$artist"
fi
