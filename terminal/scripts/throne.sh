#!/usr/bin/env bash

# Проверяем, передан ли файл
if [ -z "$1" ]; then
  echo "❌ Ошибка: Укажите путь к JSON файлу."
  echo "Использование: ./vless-converter.sh config.json"
  exit 1
fi

FILE="$1"

# Проверяем, существует ли файл
if [ ! -f "$FILE" ]; then
  echo "❌ Ошибка: Файл '$FILE' не найден."
  exit 1
fi

# Проверяем, что это VLESS
PROTOCOL=$(jq -r '.outbounds[0].protocol' "$FILE")
if [ "$PROTOCOL" != "vless" ]; then
  echo "❌ Ошибка: Этот скрипт поддерживает только протокол VLESS."
  exit 1
fi

echo "⏳ Обработка файла $FILE..."

# Вытаскиваем базовые настройки
ID=$(jq -r '.outbounds[0].settings.vnext[0].users[0].id' "$FILE")
ADDRESS=$(jq -r '.outbounds[0].settings.vnext[0].address' "$FILE")
PORT=$(jq -r '.outbounds[0].settings.vnext[0].port' "$FILE")

# Вытаскиваем сетевые настройки
NETWORK=$(jq -r '.outbounds[0].streamSettings.network // "tcp"' "$FILE")
SECURITY=$(jq -r '.outbounds[0].streamSettings.security // "none"' "$FILE")

# Вытаскиваем опциональные параметры (с защитой от null)
ENCRYPTION=$(jq -r '.outbounds[0].settings.vnext[0].users[0].encryption // empty' "$FILE")
FLOW=$(jq -r '.outbounds[0].settings.vnext[0].users[0].flow // empty' "$FILE")
SNI=$(jq -r '.outbounds[0].streamSettings.realitySettings.serverName // empty' "$FILE")
PBK=$(jq -r '.outbounds[0].streamSettings.realitySettings.publicKey // empty' "$FILE")
SID=$(jq -r '.outbounds[0].streamSettings.realitySettings.shortId // empty' "$FILE")
FP=$(jq -r '.outbounds[0].streamSettings.realitySettings.fingerprint // empty' "$FILE")

# Вытаскиваем название (remarks) и кодируем в URL-формат (чтобы эмодзи и пробелы не сломали ссылку)
REMARKS_ENCODED=$(jq -r '.remarks // "Bexum_VPN" | @uri' "$FILE")

# Собираем базовую ссылку
LINK="vless://${ID}@${ADDRESS}:${PORT}?type=${NETWORK}&security=${SECURITY}"

# Добавляем параметры, если они существуют
[ -n "$ENCRYPTION" ] && LINK="${LINK}&encryption=${ENCRYPTION}"
[ -n "$FLOW" ] && LINK="${LINK}&flow=${FLOW}"
[ -n "$SNI" ] && LINK="${LINK}&sni=${SNI}"
[ -n "$PBK" ] && LINK="${LINK}&pbk=${PBK}"
[ -n "$SID" ] && LINK="${LINK}&sid=${SID}"
[ -n "$FP" ] && LINK="${LINK}&fp=${FP}"

# Добавляем название в конец
LINK="${LINK}#${REMARKS_ENCODED}"

# Выводим результат
echo -e "\n✅ Готово! Ваша ссылка (Ctrl+Shift+C для копирования в терминале):\n"
echo -e "\033[1;32m$LINK\033[0m\n"
echo -e "$LINK" | wl-copy
echo "Теперь просто нажмите Ctrl+V в NekoRay."
