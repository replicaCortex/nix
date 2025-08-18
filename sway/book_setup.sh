BOOK_DIR="$HOME/note/book/"

swaymsg splith
swaymsg exec "footclient"
sleep 0.2
swaymsg splitv
swaymsg layout stacking
swaymsg focus left
swaymsg resize grow width 180px
swaymsg splitv
swaymsg layout stacking

cd "$BOOK_DIR" || exit
