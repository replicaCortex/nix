cat <<'EOF'
+--------------------------------------------------------+-----------------------------------------+
|                        COMMAND                         |                 ACTION                  |
+========================================================+=========================================+
|                                    PREFIX COMMANDS                                               |
+--------------------------------------------------------+-----------------------------------------+
| /t <text>                                              | Google Translate                        |
| /n <package>                                           | Search NixOS packages                   |
| http(s)://...                                          | Open specified URL in browser           |
+--------------------------------------------------------+-----------------------------------------+
|                                       SHORTCUTS                                                  |
+--------------------------------------------------------+-----------------------------------------+
| r                                                      | Reddit                                  |
| de                                                     | Deepseek Chat                           |
| go                                                     | Google AI Studio                        |
| git                                                    | GitHub                                  |
| y                                                      | YouTube                                 |
| ym                                                     | YouTube Music                           |
| w                                                      | WhatsApp Web                            |
| pin                                                    | Pinterest                               |
| 2ch                                                    | 2ch.hk                                  |
| arena                                                  | LMSys Chatbot Arena                     |
| rutrack                                                | RuTracker                               |
| timer                                                  | Online timer                            |
| sh                                                     | ShareWood                               |
+--------------------------------------------------------+-----------------------------------------+
| Enter                                                  | Exit the script                         |
+--------------------------------------------------------+-----------------------------------------+
EOF

prompt="prompt: "

read -rep "$prompt" query

BROWSER="swaymsg exec"

if [ -z "$query" ]; then
  exit 0
fi

if [[ "$query" =~ ^https?:// ]]; then
  $BROWSER --new-window "$query"

  exit 0
fi

if [[ "$query" =~ ^/t || "$query" =~ ^.е ]]; then

  query=$(echo "$query" | cut -c 4-)

  if echo "$query" | grep "[a-z]"; then
    translate="ru"
  else
    translate="en"
  fi

  $BROWSER "zen --new-window 'https://translate.google.com/?hl=ru&sl=ru&tl=$translate&text=$query&op=translate'"

  exit 0
fi

if [[ "$query" =~ ^/n ]]; then

  query=$(echo "$query" | cut -c 4-)

  $BROWSER "zen --new-window 'https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=$query'"

  exit 0
fi

case "$query" in
"r" | "к") # Reddit
  $BROWSER 'zen --new-window "https://www.reddit.com/"'
  ;;
"de" | "ву") # DeepSeek
  $BROWSER 'zen --new-window "https://chat.deepseek.com/"'
  ;;
"go" | "пщ") # Google AI Studio
  $BROWSER 'zen --new-window "https://aistudio.google.com/prompts/new_chat"'
  ;;
"timer" | "ьшсук") # Таймер
  $BROWSER 'zen --new-window "https://budilki.ru/timer/#countdown=00:00:00&enabled=0&seconds=0&sound=xylophone&loop=1"'
  ;;
"y" | "н") # YouTube
  $BROWSER 'zen --new-window "https://www.youtube.com/"'
  ;;
"ym" | "нь") # YouTube Music
  $BROWSER 'zen --new-window "https://music.youtube.com/"'
  ;;
"grok" | "пкщл") # Grok
  $BROWSER 'zen --new-window "https://grok.com/"'
  ;;
"git" | "пше") # GitHub
  $BROWSER 'zen --new-window "https://github.com/"'
  ;;
"pin" | "зшт") # Pinterest
  $BROWSER 'zen --new-window "https://ru.pinterest.com/"'
  ;;
"w" | "ц") # WhatsApp Web
  $BROWSER 'zen --new-window "https://web.whatsapp.com/"'
  ;;
"2ch" | "2ср") # 2ch
  $BROWSER 'zen --new-window "https://2ch.hk/"'
  ;;
"arena" | "фкутф") # LM Arena
  $BROWSER 'zen --new-window "https://lmarena.ai/?arena=&mode=direct"'
  ;;
"rutrack" | "кенрсфл") # Rutracker
  $BROWSER 'zen --new-window "https://rutracker.org/forum/tracker.php?nm=bruh"'
  ;;
"sh" | "ыр") # Google Translate
  $BROWSER 'zen --new-window "https://s1.sharewood.tech/"'
  ;;
*)

  query=$(sed \
    -e 's|+|%2B|g' \
    -e 's|#|%23|g' \
    -e 's|&|%26|g' \
    -e 's| |+|g' \
    <<<"$query")

  $BROWSER "zen --new-window 'https://www.google.com/search?q=$query'"
  ;;
esac
