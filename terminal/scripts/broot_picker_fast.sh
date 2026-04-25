#!/usr/bin/env bash

current_layout=$(niri msg -j keyboard-layouts | jq '.current_idx')

if [ "$current_layout" = 1 ]; then
  niri msg action switch-layout next
fi

br() {
  local cmd_file=$(mktemp)
  if broot --outcmd "$cmd_file" "$@"; then
    source "$cmd_file"
    rm -f "$cmd_file"
  else
    local code=$?
    rm -f "$cmd_file"
    return $code
  fi
}

br --conf "$XDG_CONFIG_HOME/broot/fast_open.hjson;$XDG_CONFIG_HOME/broot/conf.hjson"
