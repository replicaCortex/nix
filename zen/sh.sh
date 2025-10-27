cat <<'EOF'
+--------------------------------------------------------+-----------------------------------------+
|                        COMMAND                         |                 ACTION                  |
+========================================================+=========================================+
|                                    PREFIX COMMANDS                                               |
+--------------------------------------------------------+-----------------------------------------+
| !<text>                                                | Google Translate                        |
| @<package>                                             | Search NixOS packages                   |
| http(s)://...                                          | Open specified URL in browser           |
+--------------------------------------------------------+-----------------------------------------+
|                                       SHORTCUTS                                                  |
+--------------------------------------------------------+-----------------------------------------+
| r                                                      | Reddit                                  |
| du                                                     | Duck.ai                                 |
| git                                                    | GitHub                                  |
| y                                                      | YouTube                                 |
| ym                                                     | YouTube Music                           |
| w                                                      | WhatsApp Web                            |
| wo                                                     | World                                   |
| sh                                                     | Shedule                                 |
| be                                                     | Beline (poor)                           |
| sdo                                                    | Sdo                                     |
| p                                                      | Photopea                                |
| oc                                                     | OC                                      |
| 2ch                                                    | 2ch.hk                                  |
| de                                                     | DeepSeek                                |
| rutrack                                                | RuTracker                               |
| tulp                                                   | Tulp. tavern                            |
| tulpWiki                                               | Tulp. wiki                              |
| shed                                                   | ShareWood                               |
+--------------------------------------------------------+-----------------------------------------+
| Enter                                                  | Exit the script                         |
+--------------------------------------------------------+-----------------------------------------+
EOF

prompt="prompt: "

read -rep "$prompt" query

SWAY="swaymsg exec"
# BROWSER="vimb"
# BROWSER="librewolf --new-window"
BROWSER="zen --new-window"

if [ -z "$query" ]; then
  exit 0
fi

if [[ "$query" =~ ^\! || "$query" =~ ^\! ]]; then

  query=$(echo "$query" | cut -c 2-)

  if echo "$query" | grep "[a-z]"; then
    translate="ru"
  else
    translate="en"
  fi

  $SWAY "$BROWSER 'https://translate.google.com/?hl=en&sl=en&tl=$translate&text=$query&op=translate'"

  exit 0
fi

regex='https?://[-[:alnum:]\+&@#/%?=~_|!:,.;]*[-[:alnum:]\+&@#/%=~_|]'

if [[ "$query" =~ $regex ]]; then
  $SWAY "$BROWSER \"$query\""

  exit 0
fi

if [[ "$query" =~ ^\@ ]]; then

  query=$(echo "$query" | cut -c 2-)

  $SWAY "$BROWSER 'https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=$query'"

  exit 0
fi

case "$query" in
"r" | "к") # Reddit
  $SWAY "$BROWSER 'https://old.reddit.com/'"
  ;;
"de" | "ву") # DeepSeek
  $SWAY "$BROWSER 'https://chat.deepseek.com/'"
  ;;
"go" | "пщ") # Google AI Studio
  export http_proxy=$PROXY
  $SWAY "$BROWSER 'https://aistudio.google.com/prompts/new_chat'"
  ;;
"timer" | "ьшсук") # Таймер
  $SWAY "$BROWSER 'https://budilki.ru/timer/#countdown=00:00:00&enabled=0&seconds=0&sound=xylophone&loop=1'"
  ;;
# "y" | "н") # YouTube
#   $SWAY "$BROWSER 'https://www.youtube.com/'"
#   ;;
# "ym" | "нь") # YouTube Music
#   $SWAY '$BROWSER "https://music.youtube.com/"'
#   ;;
# "grok" | "пкщл") # Grok
#   $SWAY '$BROWSER "https://grok.com/"'
#   ;;
"git" | "пше") # GitHub
  $SWAY "$BROWSER 'https://github.com/'"
  ;;
"w" | "ц") # WhatsApp Web
  $SWAY "$BROWSER 'https://web.whatsapp.com/'"
  ;;
"p" | "з") # WhatsApp Web
  $SWAY "$BROWSER 'https://www.photopea.com/'"
  ;;
"2ch" | "2ср") # 2ch
  $SWAY "$BROWSER 'https://2ch.su/'"
  ;;
# "arena" | "фкутф") # LM Arena
#   $SWAY '$BROWSER "https://lmarena.ai/?arena=&mode=direct"'
#   ;;
# "rutrack" | "кенрсфл") # Rutracker
#   $SWAY '$BROWSER "https://rutracker.org/forum/tracker.php?nm=bruh"'
#   ;;
"sh" | "ыр") # Google Translate
  $SWAY "$BROWSER 'https://npi-tu.ru/schedule/schedule.html?for=student&faculty=2&year=3&group=%D0%9F%D0%9E%D0%92%D0%B0'"
  ;;
"wo" | "цщ") # world
  $SWAY "$BROWSER 'https://docs.google.com/document/u/0/'"
  ;;
"shed" | "ырув") #
  $SWAY "$BROWSER 'https://s1.sharewood.tech/'"
  ;;
"nb" | "тм") #
  $SWAY "$BROWSER 'https://notebooklm.google.com/?authuser=1'"
  ;;
# "ch" | "ср") #
#   $SWAY "$BROWSER 'https://chatgpt.com/'"
#   ;;
"be" | "иу") #
  $SWAY "$BROWSER 'https://rostov-na-donu.beeline.ru/customers/products/elk/'"
  ;;
"du" | "вг") #
  $SWAY "$BROWSER 'https://duckduckgo.com/?q=DuckDuckGo+AI+Chat&ia=chat&duckai=1'"
  ;;
"sdo" | "ывщ") #
  $SWAY "$BROWSER 'https://sdo.npi-tu.ru/'"
  ;;
"oc" | "щс") #
  $SWAY "$BROWSER 'https://sdo.srspu.ru/course/view.php?id=40278'"
  ;;
"vk" | "мл") #
  $SWAY "$BROWSER 'https://vk.com/im'"
  ;;
"tulp" | "егдз") #
  $SWAY "$BROWSER 'https://2ch.su/se/res/140778.html'"
  ;;
"tulpwiki" | "егдзцшлш") #
  $SWAY "$BROWSER 'https://tulpawiki.org/archive/'"
  ;;
"manga" | "ьфтпф") #
  $SWAY "$BROWSER 'https://mangadex.org/titles/follows'"
  ;;
*)

  query=$(sed \
    -e 's|+|%2B|g' \
    -e 's|#|%23|g' \
    -e 's|&|%26|g' \
    -e 's| |+|g' \
    <<<"$query")

  $SWAY "$BROWSER 'https://www.duckduckgo.com/search?q=$query'"
  ;;
esac
