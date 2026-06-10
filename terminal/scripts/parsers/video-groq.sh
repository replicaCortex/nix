#!/usr/bin/env bash

[ -z "$GROQ_API_KEY" ] && exit 0
command -v ffmpeg >/dev/null 2>&1 || exit 0
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
mp4 | mkv | avi | mov | webm | flv | wmv | m4v) ;;
*)
  exit 0
  ;;
esac

hash_id=$(echo -n "$raw_filename" | md5sum | awk '{print $1}' | cut -c 1-6)
temp_audio="/tmp/audio_${hash_id}.mp3"

ffmpeg -y -nostdin -ss 30 -i "$raw_filename" -t 120 -vn -acodec libmp3lame -ar 16000 -ac 1 "$temp_audio" >/dev/null 2>&1

[ ! -f "$temp_audio" ] && exit 0

whisper_response=$(curl -s -w "%{http_code}" -X POST "https://api.groq.com/openai/v1/audio/transcriptions" \
  -H "Authorization: Bearer $GROQ_API_KEY" \
  -F "file=@$temp_audio" \
  -F "model=whisper-large-v3-turbo" \
  -F "response_format=json")

http_code_whisper="${whisper_response: -3}"
body_whisper="${whisper_response:0:${#whisper_response}-3}"

rm -f "$temp_audio"

[ "$http_code_whisper" -ne 200 ] && exit 0

transcript=$(echo "$body_whisper" | jq -r '.text // empty' 2>/dev/null)
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

llama_response=$(curl -s -w "%{http_code}" -X POST "https://api.groq.com/openai/v1/chat/completions" \
  -H "Authorization: Bearer $GROQ_API_KEY" \
  -H "Content-Type: application/json" \
  -d "$JSON_PAYLOAD")

http_code_llama="${llama_response: -3}"
body_llama="${llama_response:0:${#llama_response}-3}"

[ "$http_code_llama" -ne 200 ] && exit 0

tags_json=$(echo "$body_llama" | jq -r '.choices[0].message.content' 2>/dev/null)

echo "$tags_json" | jq -r '.tags[] // empty' 2>/dev/null | sed -E 's/[[:space:]]+/-/g' | tr '[:upper:]' '[:lower:]' | xargs
