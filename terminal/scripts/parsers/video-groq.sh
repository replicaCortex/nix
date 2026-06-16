#!/usr/bin/env bash

# Включаем pipefail, чтобы ловить ошибки внутри пайплайнов
set -o pipefail
shopt -s extglob

[ -z "$GROQ_API_KEY" ] && exit 0
for cmd in ffmpeg curl jq; do
  command -v "$cmd" >/dev/null 2>&1 || exit 0
done

raw_filename="$1"
[ -z "$raw_filename" ] && exit 1

# Нативное получение расширения и приведение к нижнему регистру
ext="${raw_filename##*.}"
[[ "$raw_filename" == *.* ]] && ext_lower="${ext,,}" || ext_lower=""

case "$ext_lower" in
mp4 | mkv | avi | mov | webm | flv | wmv | m4v) ;;
*)
  exit 0
  ;;
esac

# 1. Безопасное создание временного файла
temp_audio=$(mktemp --suffix=.mp3)
# trap гарантирует удаление mp3-файла при завершении или ошибке скрипта
trap 'rm -f "$temp_audio"' EXIT

# 2. Оптимизированный ffmpeg (максимально тихий, битрейт 32k для ускорения upload'а)
ffmpeg -y -hide_banner -loglevel error -ss 30 -i "$raw_filename" -t 120 \
  -vn -acodec libmp3lame -ar 16000 -ac 1 -b:a 32k "$temp_audio"

# Если ffmpeg упал и файл пуст - выходим
[ ! -s "$temp_audio" ] && exit 0

# 3. Запрос к Whisper
whisper_response=$(curl -s -w "%{http_code}" -X POST "https://api.groq.com/openai/v1/audio/transcriptions" \
  -H "Authorization: Bearer $GROQ_API_KEY" \
  -F "file=@$temp_audio" \
  -F "model=whisper-large-v3-turbo" \
  -F "response_format=json")

http_code_whisper="${whisper_response: -3}"
body_whisper="${whisper_response:0:${#whisper_response}-3}"

[ "$http_code_whisper" -ne 200 ] && exit 0

transcript=$(jq -r '.text // empty' <<<"$body_whisper" 2>/dev/null)
[ -z "$transcript" ] && exit 0

PROMPT="Analyze this video speech transcript and generate 5-10 relevant tags representing the main topics, themes, or category of the video.

Rules:
- Return ONLY a valid JSON object with key \"tags\" containing array of strings. Do not wrap in markdown \`\`\`json.
- Tags must be single words or kebab-case (e.g. \"tutorial\", \"nixos-setup\", \"gaming\").
- Language: You must output tags ONLY in English. Translate any concepts to English.

Transcript:
\"\"\"
$transcript
\"\"\""

JSON_PAYLOAD=$(jq -n --arg model "llama-3.1-8b-instant" --arg prompt "$PROMPT" \
  '{model: $model, response_format: {type: "json_object"}, messages: [{role: "user", content: $prompt}]}')

# 4. Запрос к LLaMA
llama_response=$(curl -s -w "%{http_code}" -X POST "https://api.groq.com/openai/v1/chat/completions" \
  -H "Authorization: Bearer $GROQ_API_KEY" \
  -H "Content-Type: application/json" \
  -d "$JSON_PAYLOAD")

http_code_llama="${llama_response: -3}"
body_llama="${llama_response:0:${#llama_response}-3}"

[ "$http_code_llama" -ne 200 ] && exit 0

tags_json=$(jq -r '.choices[0].message.content // empty' <<<"$body_llama" 2>/dev/null)
[ -z "$tags_json" ] && exit 0

# 5. МАГИЯ JQ: Парсим, приводим в lower_case и меняем пробелы на дефисы прямо внутри jq!
# Это заменяет 3 команды: sed, tr и дополнительный echo.
jq -r '.tags[]? | strings | ascii_downcase | gsub("[ \\t]+"; "-")' <<<"$tags_json" 2>/dev/null | xargs
