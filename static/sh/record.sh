#!/usr/bin/env bash

INRES="1920x1080"
OUTRES="1920x1080"
FPS="30"

ffmpeg -f x11grab -s "$INRES" -r "$FPS" -i :0.0 \
    -vcodec libx264 -s "$OUTRES" \
    -b:v 3M -maxrate 10M -bufsize 10M \
    -threads 0 -f flv $1
