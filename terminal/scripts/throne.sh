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

echo "⏳ Обработка файла $FILE..."

# Определяем протокол
PROTOCOL=$(jq -r '.outbounds[0].protocol' "$FILE")
REMARKS_ENCODED=$(jq -r '.remarks // "Bexum_VPN" | @uri' "$FILE")

if [ "$PROTOCOL" == "vless" ]; then
  echo "🔍 Обнаружен протокол: VLESS"

  ID=$(jq -r '.outbounds[0].settings.vnext[0].users[0].id' "$FILE")
  ADDRESS=$(jq -r '.outbounds[0].settings.vnext[0].address' "$FILE")
  PORT=$(jq -r '.outbounds[0].settings.vnext[0].port' "$FILE")

  NETWORK=$(jq -r '.outbounds[0].streamSettings.network // "tcp"' "$FILE")
  SECURITY=$(jq -r '.outbounds[0].streamSettings.security // "none"' "$FILE")

  ENCRYPTION=$(jq -r '.outbounds[0].settings.vnext[0].users[0].encryption // empty' "$FILE")
  FLOW=$(jq -r '.outbounds[0].settings.vnext[0].users[0].flow // empty' "$FILE")
  SNI=$(jq -r '.outbounds[0].streamSettings.realitySettings.serverName // empty' "$FILE")
  PBK=$(jq -r '.outbounds[0].streamSettings.realitySettings.publicKey // empty' "$FILE")
  SID=$(jq -r '.outbounds[0].streamSettings.realitySettings.shortId // empty' "$FILE")
  FP=$(jq -r '.outbounds[0].streamSettings.realitySettings.fingerprint // empty' "$FILE")

  LINK="vless://${ID}@${ADDRESS}:${PORT}?type=${NETWORK}&security=${SECURITY}"

  [ -n "$ENCRYPTION" ] && LINK="${LINK}&encryption=${ENCRYPTION}"
  [ -n "$FLOW" ] && LINK="${LINK}&flow=${FLOW}"
  [ -n "$SNI" ] && LINK="${LINK}&sni=${SNI}"
  [ -n "$PBK" ] && LINK="${LINK}&pbk=${PBK}"
  [ -n "$SID" ] && LINK="${LINK}&sid=${SID}"
  [ -n "$FP" ] && LINK="${LINK}&fp=${FP}"

elif [ "$PROTOCOL" == "trojan" ]; then
  echo "🔍 Обнаружен протокол: Trojan"

  PASSWORD=$(jq -r '.outbounds[0].settings.servers[0].password' "$FILE")
  ADDRESS=$(jq -r '.outbounds[0].settings.servers[0].address' "$FILE")
  PORT=$(jq -r '.outbounds[0].settings.servers[0].port' "$FILE")

  NETWORK=$(jq -r '.outbounds[0].streamSettings.network // "tcp"' "$FILE")
  SECURITY=$(jq -r '.outbounds[0].streamSettings.security // "none"' "$FILE")

  # Для Trojan настройки TLS лежат в tlsSettings, а не в realitySettings
  SNI=$(jq -r '.outbounds[0].streamSettings.tlsSettings.serverName // empty' "$FILE")
  FP=$(jq -r '.outbounds[0].streamSettings.tlsSettings.fingerprint // empty' "$FILE")

  LINK="trojan://${PASSWORD}@${ADDRESS}:${PORT}?type=${NETWORK}&security=${SECURITY}"

  [ -n "$SNI" ] && LINK="${LINK}&sni=${SNI}"
  [ -n "$FP" ] && LINK="${LINK}&fp=${FP}"

else
  echo "❌ Ошибка: Этот скрипт пока поддерживает только протоколы VLESS и Trojan."
  echo "Текущий протокол в файле: $PROTOCOL"
  exit 1
fi

# Добавляем название в конец
LINK="${LINK}#${REMARKS_ENCODED}"

# Выводим результат
echo -e "\n✅ Готово! Ваша ссылка:\n"
echo -e "\033[1;32m$LINK\033[0m\n"

# Копируем в буфер (оставил ваш wl-copy, если вы на Wayland. Если на X11, замените на xclip -selection clipboard)
echo -n "$LINK" | wl-copy
echo "Ссылка скопирована! Теперь просто нажмите Ctrl+V в NekoRay."
