#!/usr/bin/env bash

SELECTED_DIR=$(fd -t d | fzf --prompt="Vidir Target> ")

[ -z "$SELECTED_DIR" ] && exit 0

cd "$SELECTED_DIR" || exit 1

clear
fd -t f | sort | "${DOTFILES}/terminal/scripts/vidir.sh"
