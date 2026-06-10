#!/usr/bin/env bash
filename="$1"

if [[ "$filename" =~ ^([0-9]+)_[0-9]+_[^_]+_(.*)\.[0-9a-f]{32} ]]; then
  art_id="${BASH_REMATCH[1]}"
  title="${BASH_REMATCH[2]}"

  clean_title="${title%-$art_id}"

  echo "$clean_title"
fi
