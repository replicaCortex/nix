swaymsg exec "footclient"
sleep 0.2
swaymsg focus left
swaymsg move right

cd "$HOME/note/media/" || return
