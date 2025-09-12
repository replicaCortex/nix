if [ -z "$1" ]; then
  echo "time?"
  return 0
fi

IFS=":" read -ra array <<<"$1"

num_parts=${#array[@]}

if [ "$num_parts" = 3 ]; then
  h=${array[0]}
  m=${array[1]}
  s=${array[2]}
fi

if [ "$num_parts" = 2 ]; then
  m=${array[0]}
  s=${array[1]}
fi

if [ "$num_parts" = 1 ]; then
  s=${array[0]}
fi

timer=$((h * 3600 + m * 60 + s))

if [ "$2" = "by" ]; then
  if [[ -z $h ]]; then
    h=0
  fi
  if [[ -z $m ]]; then
    m=0
  fi
  if [[ -z $s ]]; then
    s=0
  fi

  date_by=$(date -d "today $h:$m:$s" +%s)
  date_now=$(date -d "now" +%s)

  delta=$((date_by - date_now))

  if [ $delta -le 0 ]; then
    echo "error time to: ${delta}"
    exit 1
  fi

  timer=$delta
fi

for ((i = 1; i <= timer; i++)); do
  h_l=$(((timer - i) / 3600))
  m_l=$((((timer - i) % 3600) / 60))
  s_l=$(((timer - i) % 60))

  h_p=$((i / 3600))
  m_p=$(((i % 3600) / 60))
  s_p=$((i % 60))

  printf "passed: %02d:%02d:%02d, left: %02d:%02d:%02d\n" "$h_p" "$m_p" "$s_p" "$h_l" "$m_l" "$s_l"
  sleep 1
done

dunstify "󰀠  Alarm!" "Timeout" -t 4000 && paplay --volume=60000 ~/nix/**/AlertSound.mp3
