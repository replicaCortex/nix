FOCUSED_WINDOW_INFO=$(niri msg -j focused-window)

TITLE=$(echo "$FOCUSED_WINDOW_INFO" | jq -r '.title')

CWD_STRING=""

if [ -z "$TITLE" ] || [ "$TITLE" = "null" ]; then
  footclient --working-directory "$HOME"
  exit 0
fi

if [[ "$TITLE" == *"("*")"* ]]; then
  CWD_STRING=$(echo "$TITLE" | grep -oP '\(\K[^\)]+')
fi

if [ -z "$CWD_STRING" ] && [[ "$TITLE" == *": "* ]]; then
  CWD_STRING=$(echo "$TITLE" | sed -n 's/.*: \(.*\)/\1/p')
fi

if [ -z "$CWD_STRING" ]; then
  footclient --working-directory "$HOME"
  exit 0
fi

EXPANDED_CWD=$(eval echo "$CWD_STRING")

FINAL_CWD=""

if [ -d "$EXPANDED_CWD" ]; then
  FINAL_CWD="$EXPANDED_CWD"
else
  DIR_OF_PATH=$(dirname "$EXPANDED_CWD")
  if [ -d "$DIR_OF_PATH" ]; then
    FINAL_CWD="$DIR_OF_PATH"
  fi
fi

if [ -n "$FINAL_CWD" ]; then
  footclient --working-directory "$FINAL_CWD"
else
  footclient --working-directory "$HOME"
fi
