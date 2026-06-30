#!/usr/bin/env bash

QUTE_FILE="$1"

MY_TEMP=$(mktemp -d /tmp/qutebrowser-editor-XXXXX)
cp $QUTE_FILE $MY_TEMP

$TERMINAL -e $EDITOR "$MY_TEMP"

cat "$MY_TEMP" >"$QUTE_FILE"

wl-copy <"$MY_TEMP"
rm "$MY_TEMP"
