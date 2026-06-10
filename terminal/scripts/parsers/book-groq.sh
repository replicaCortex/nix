#!/usr/bin/env bash

[ -z "$GROQ_API_KEY" ] && exit 0
command -v mutool >/dev/null 2>&1 || exit 0
command -v curl >/dev/null 2>&1 || exit 0
command -v jq >/dev/null 2>&1 || exit 0

raw_filename="$1"
[ -z "$raw_filename" ] && exit 1

if [[ "$raw_filename" == *.* ]]; then
  ext_lower=$(echo "${raw_filename##*.}" | tr '[:upper:]' '[:lower:]')
else
  ext_lower=""
fi

case "$ext_lower" in
pdf | epub | fb2 | mobi | djvu | azw | azw3) ;;
*)
  exit 0
  ;;
esac

book_text=$(mutool draw -o - "$raw_filename" 5-15 2>/dev/null | head -c 8000 | tr -d '\000-\011\013\014\016-\037')
readable_filename=$(echo "$raw_filename" | tr '_' ' ' | sed -E 's/\[[^]]*\]//g' | sed 's/  */ /g' | sed 's/^ //; s/ $//')

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

author=$(echo "$body" | jq -r '.choices[0].message.content' 2>/dev/null | jq -r '.author // empty' 2>/dev/null)
title=$(echo "$body" | jq -r '.choices[0].message.content' 2>/dev/null | jq -r '.title // empty' 2>/dev/null)
year=$(echo "$body" | jq -r '.choices[0].message.content' 2>/dev/null | jq -r '.year // empty' 2>/dev/null)
content_tags=$(echo "$body" | jq -r '.choices[0].message.content' 2>/dev/null | jq -r '.tags[] // empty' 2>/dev/null | sed -E 's/[[:space:]]+/-/g' | tr '[:upper:]' '[:lower:]' | xargs)

[[ "${author,,}" =~ ^(unknown|null|none|n/a|не\ указан.*|неизвест.*)$ ]] && author=""
[[ "${title,,}" =~ ^(unknown|null|none|n/a|не\ указан.*|неизвест.*)$ ]] && title=""
[[ "${year,,}" =~ ^(unknown|null|none|n/a|не\ указан.*|неизвест.*)$ ]] && year=""

tags=""
[ -n "$author" ] && tags="author=\"$author\""
[ -n "$year" ] && tags="$tags year=\"$year\""
[ -n "$title" ] && tags="$tags title=\"$title\""
[ -n "$content_tags" ] && tags="$tags $content_tags"

echo "$tags"
