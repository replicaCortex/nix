cp ~/.zen/*.Default*/places.sqlite /tmp/tmp_places_zen.sqlite

tmpfile="/tmp/tmp_custom_promt_fzf"
historytmpfile="/tmp/tmp_history"

rm -f $tmpfile
rm -f $historytmpfile

select_=$(
  sqlite3 /tmp/tmp_places_zen.sqlite \
    "SELECT b.title || ' ' || p.url FROM moz_bookmarks b JOIN moz_places p ON b.fk = p.id;" |
    fzf \
      --bind "ctrl-g:execute(footclient --app-id=cliphist bash -c 'echo -e \"爱\" | fzf --print-query > /tmp/tmp_custom_promt_fzf')+abort" \
      --bind "ctrl-h:execute(footclient --app-id=cliphist bash -c 'select_=\$(sqlite3 /tmp/tmp_places_zen.sqlite \"SELECT id, title, url FROM moz_places ORDER BY id DESC LIMIT 500\" | fzf | grep -o \"https\\?://[^ ]*\"); echo \$select_ > /tmp/tmp_history')+abort"
)

if [ -f $historytmpfile ]; then

  select_=$(<$historytmpfile)

  if [ -z "$select_" ]; then
    zen --new-window "$select_"
  fi
fi

if [ -f $tmpfile ]; then
  select_=$(<$tmpfile)
  zen --new-window --search "$select_"
else

  if [ -z "$select_" ]; then
    exit 0
  fi

  select_=$(echo "$select_" | grep -o 'https\?://[^ ]*')
  zen --new-window "$select_"
fi
