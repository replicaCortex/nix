if [ -z "$1" ]; then
  echo "file name?"
  exit 0
fi

ffmpeg -f alsa -i default -t 30 ~/"$1".mp3

echo "file '$1'.mp3 saved in ~/"
