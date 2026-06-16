#!/usr/bin/env bash

shopt -s extglob

[ -z "$GROQ_API_KEY" ] && exit 0
for cmd in mutool curl jq; do
  command -v "$cmd" >/dev/null 2>&1 || exit 0
done

raw_filename="$1"
[ -z "$raw_filename" ] && exit 1

# Нативное получение расширения и приведение к нижнему регистру
ext="${raw_filename##*.}"
[[ "$raw_filename" == *.* ]] && ext_lower="${ext,,}" || ext_lower=""

case "$ext_lower" in
pdf | epub | fb2 | mobi | djvu | azw | azw3) ;;
*)
  exit 0
  ;;
esac

# Изменено: страницы 1-12 (чтобы точно захватить титульник и copyright-страницу)
# Изменено: tr -cd оставляет только печатные символы, пробелы и переносы строк
book_text=$(mutool draw -o - "$raw_filename" 1-12 2>/dev/null | head -c 8000 | tr -cd '\11\12\40-\176\200-\377')

# Нативная очистка имени (без множественных седов)
readable_filename="${raw_filename//_/ }"
readable_filename=$(sed -E 's/\[[^]]*\]//g' <<<"$readable_filename")
readable_filename="${readable_filename//+([[:space:]])/ }"
readable_filename="${readable_filename##+([[:space:]])}"
readable_filename="${readable_filename%%+([[:space:]])}"

PROMPT="You are a strict book indexing tool. Analyze the filename and the text snippet.
Extract the metadata (author, title, year) and generate 5-10 descriptive kebab-case tags (genres, themes, subjects).

Rules:
- Return ONLY a valid JSON object. Do not wrap in markdown \`\`\`json.
- Keys: \"author\" (string or null), \"title\" (string or null), \"year\" (string or null), \"tags\" (array of strings).
- If value is missing, use null.
- Tags must be kebab-case (e.g. \"ancient-philosophy\", \"linear-algebra\", \"scifi\"). No spaces.
- Language of tags: You must output tags ONLY in English. Translate any Russian genres or concepts to English (e.g., \"научная фантастика\" -> \"sci-fi\", \"сказка\" -> \"fairytale\").

Filename: '$readable_filename'
Text Snippet:
\"\"\"
$book_text
\"\"\""

JSON_PAYLOAD=$(jq -n --arg model "llama-3.3-70b-versatile" --arg prompt "$PROMPT" \
  '{model: $model, response_format: {type: "json_object"}, messages: [{role: "user", content: $prompt}]}')

response=$(curl -s -w "%{http_code}" -X POST "https://api.groq.com/openai/v1/chat/completions" \
  -H "Authorization: Bearer $GROQ_API_KEY" \
  -H "Content-Type: application/json" \
  -d "$JSON_PAYLOAD")

http_code="${response: -3}"
body="${response:0:${#response}-3}"

[ "$http_code" -ne 200 ] && exit 0

# --- ОПТИМИЗАЦИЯ ---
# Извлекаем внутренний JSON (ответ LLM) всего один раз
llm_json=$(jq -r '.choices[0].message.content // empty' <<<"$body" 2>/dev/null)
[ -z "$llm_json" ] && exit 0

# Теперь парсим поля напрямую из извлеченного текста (работает в 4 раза быстрее)
author=$(jq -r '.author // empty' <<<"$llm_json" 2>/dev/null)
title=$(jq -r '.title // empty' <<<"$llm_json" 2>/dev/null)
year=$(jq -r '.year // empty' <<<"$llm_json" 2>/dev/null)

# xargs собирает теги в одну строчку через пробел
content_tags=$(jq -r '.tags[]? // empty' <<<"$llm_json" 2>/dev/null | sed -E 's/[[:space:]]+/-/g' | tr '[:upper:]' '[:lower:]' | xargs)

# Нативная проверка на мусор (,, приводит к lower case)
[[ "${author,,}" =~ ^(unknown|null|none|n/a|не\ указан.*|неизвест.*)$ ]] && author=""
[[ "${title,,}" =~ ^(unknown|null|none|n/a|не\ указан.*|неизвест.*)$ ]] && title=""
[[ "${year,,}" =~ ^(unknown|null|none|n/a|не\ указан.*|неизвест.*)$ ]] && year=""

tags=""
[ -n "$author" ] && tags="author=\"$author\""
[ -n "$year" ] && tags="$tags year=\"$year\""
[ -n "$title" ] && tags="$tags title=\"$title\""
[ -n "$content_tags" ] && tags="$tags $content_tags"

# Вывод с отсечением лишнего пробела спереди (если author и year пусты)
tags="${tags##+([[:space:]])}"
echo "$tags"
