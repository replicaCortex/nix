query=$(cat)

if [[ -n $* ]]; then
  query=$*
fi

if [[ $query =~ [а-яА-Я] ]]; then
  translate="en"
else
  translate="ru"
fi

result="$(translatepy translate --text "$query" --dest-lang $translate | grep result | cut -c 16- | sed 's/\\"/"/g')"

printf "%b\n" "${result::-1}"
