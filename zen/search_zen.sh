cp ~/.zen/*.Default*/places.sqlite /tmp/tmp_places_zen.sqlite

tmpfile="/tmp/tmp_custom_promt_fzf"
historytmpfile="/tmp/tmp_history"
tmptranslatefile="/tmp/tmp_translate_promt_fzf"

rm -f $tmpfile
rm -f $historytmpfile
rm -f $tmptranslatefile

select_=$(
  sqlite3 /tmp/tmp_places_zen.sqlite \
    "SELECT b.title || ' ' || p.url FROM moz_bookmarks b JOIN moz_places p ON b.fk = p.id;" |
    fzf \
      --header="ctrl-g -   search | ctrl-h -  search | ctrl-t - 󰗊 translate | I\`m freak  " \
      --bind "ctrl-g:execute(footclient --app-id=cliphist bash -c 'echo -e \"Γκούγκλ\" | fzf --print-query > /tmp/tmp_custom_promt_fzf')+abort" \
      --bind "ctrl-t:execute(footclient --app-id=cliphist bash -c 'echo -e \"Τρανσλατε\" | fzf --print-query > /tmp/tmp_translate_promt_fzf')+abort" \
      --bind "ctrl-h:execute(footclient --app-id=cliphist bash -c 'select_=\$(sqlite3 /tmp/tmp_places_zen.sqlite \"SELECT title, url FROM moz_places ORDER BY id DESC LIMIT 500\" | fzf | grep -o \"https\\?://[^ ]*\"); echo \$select_ > /tmp/tmp_history')+abort"
)

if [ -f "$historytmpfile" ]; then
  select_=$(<"$historytmpfile")

  if [ -z "$select_" ]; then
    exit 0
  fi

  zen --new-window "$select_"
  exit 0
fi

if [ -f "$tmpfile" ]; then
  select_=$(<"$tmpfile")

  if [ -z "$select_" ]; then
    exit 0
  fi

  if [[ "$select_" =~ ^https?:// ]]; then
    zen --new-window "$select_"
    exit 0
  fi

  zen --new-window --search "$select_"
  exit 0
fi

if [ -f "$tmptranslatefile" ]; then
  select_=$(<"$tmptranslatefile")

  if [ -z "$select_" ]; then
    exit 0
  fi

  if echo "$select_" | grep "[a-z]"; then
    translate="ru"
  else
    translate="en"
  fi

  zen --new-window "https://translate.google.com/?hl=ru&sl=ru&tl=$translate&text=$select_&op=translate"
  exit 0
fi

if [ -z "$select_" ]; then
  exit 0
fi

select_=$(echo "$select_" | grep -o 'https\?://[^ ]*')
zen --new-window "$select_"
