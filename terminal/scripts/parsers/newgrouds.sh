#!/usr/bin/env bash

file="$1"
[ -z "$file" ] && exit 0

artist=""

if [[ "$file" =~ ^[0-9]+_[0-9]+_([^_]+)_ ]]; then
  artist="${BASH_REMATCH[1]}"

elif [[ "$file" =~ ^newgrounds_(None|[0-9]+)_((None|[0-9]+)_)?([^_]+)_ ]]; then
  artist="${BASH_REMATCH[4]}"
fi

if [ -n "$artist" ]; then
  echo "newgrounds @$artist "
fi
