#!/usr/bin/env bash

if [ -z "$1" ]; then
  echo "name file"
  exit 0
fi

wf-recorder -f "$1.mkv" -c libx264 -m matroska -r 24 -p bitrate=3000k -p bufsize=3000k
