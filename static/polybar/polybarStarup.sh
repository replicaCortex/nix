killall -q polybar
while pgrep -u "$UID" -x polybar >/dev/null; do sleep 1; done

DIR="$HOME/.config/polybar"

polybar -q bar1 -c "$DIR/config.ini" &
polybar -q bar2 -c "$DIR/config.ini" &
polybar -q bar3 -c "$DIR/config.ini" &
