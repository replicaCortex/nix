#!/usr/bin/env bash

fd -t f | sort | "${DOTFILES}/terminal/scripts/vidir.sh"
