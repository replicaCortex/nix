#!/usr/bin/env bash

TMP_FILE=$(mktemp /tmp/XXXX.json)
wl-paste >"$TMP_FILE"

FILE="$TMP_FILE"

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

  SNI=$(jq -r '.outbounds[0].streamSettings.tlsSettings.serverName // empty' "$FILE")
  FP=$(jq -r '.outbounds[0].streamSettings.tlsSettings.fingerprint // empty' "$FILE")

  LINK="trojan://${PASSWORD}@${ADDRESS}:${PORT}?type=${NETWORK}&security=${SECURITY}"

  [ -n "$SNI" ] && LINK="${LINK}&sni=${SNI}"
  [ -n "$FP" ] && LINK="${LINK}&fp=${FP}"

elif [ "$PROTOCOL" == "hysteria" ]; then
  # Проверяем версию (в вашем файле это версия 2)
  VERSION=$(jq -r '.outbounds[0].settings.version // .outbounds[0].streamSettings.hysteriaSettings.version // "1"' "$FILE")

  ADDRESS=$(jq -r '.outbounds[0].settings.address' "$FILE")
  PORT=$(jq -r '.outbounds[0].settings.port' "$FILE")
  AUTH=$(jq -r '.outbounds[0].streamSettings.hysteriaSettings.auth // empty' "$FILE")

  SNI=$(jq -r '.outbounds[0].streamSettings.tlsSettings.serverName // empty' "$FILE")
  FP=$(jq -r '.outbounds[0].streamSettings.tlsSettings.fingerprint // empty' "$FILE")
  ALPN=$(jq -r '.outbounds[0].streamSettings.tlsSettings.alpn | join(",") // empty' "$FILE")

  if [ "$VERSION" == "2" ]; then
    echo "🔍 Обнаружен протокол: Hysteria 2"
    # Формат Hysteria 2: hysteria2://auth@address:port?sni=...&fp=...&alpn=...
    LINK="hysteria2://${AUTH}@${ADDRESS}:${PORT}?"
    [ -n "$SNI" ] && LINK="${LINK}sni=${SNI}&"
    [ -n "$FP" ] && LINK="${LINK}fp=${FP}&"
    [ -n "$ALPN" ] && LINK="${LINK}alpn=${ALPN}&"
    LINK="${LINK%&}" # Удаляем лишний '&' на конце
    LINK="${LINK%?}" # Удаляем лишний '?', если параметров нет
  else
    echo "🔍 Обнаружен протокол: Hysteria 1"
    # Формат Hysteria 1: hysteria://address:port?auth=...&sni=...&alpn=...
    LINK="hysteria://${ADDRESS}:${PORT}?auth=${AUTH}"
    [ -n "$SNI" ] && LINK="${LINK}&peer=${SNI}"
    [ -n "$ALPN" ] && LINK="${LINK}&alpn=${ALPN}"
  fi

else
  echo "❌ Ошибка: Этот скрипт пока поддерживает только VLESS, Trojan и Hysteria."
  echo "Текущий протокол в файле: $PROTOCOL"
  exit 1
fi

# Добавляем название в конец
LINK="${LINK}#${REMARKS_ENCODED}"

# Выводим результат
echo -e "\n✅ Готово! Ваша ссылка:\n"
echo -e "\033[1;32m$LINK\033[0m\n"

# Копируем в буфер обмена (wl-copy для Wayland)
if command -v wl-copy &>/dev/null; then
  echo -n "$LINK" | wl-copy
  echo "Ссылка скопирована в буфер обмена! Теперь просто нажмите Ctrl+V в NekoRay."
elif command -v xclip &>/dev/null; then
  echo -n "$LINK" | xclip -selection clipboard
  echo "Ссылка скопирована в буфер обмена (через xclip)!"
else
  echo "⚠️ Утилита wl-copy или xclip не найдена. Скопируйте ссылку вручную из терминала."
fi
