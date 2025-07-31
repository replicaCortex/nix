if [ -z "$1" ]; then
  echo "file name?"
  exit 0
fi

trash=$(mktemp)

ffmpeg -f alsa -i hw:1,0 -t 30 "$trash".mp3
ffmpeg -i "$trash".mp3 -af "volume=0.04" ~/"$1".mp3

echo "file '$1' saved in ~/"
