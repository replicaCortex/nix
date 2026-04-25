function run_once {
  if ! pgrep -f "$1" >/dev/null; then
    niri msg action spawn-sh -- "${2:-$1}"
  fi
}

run_once "dunst"
run_once "waybar"

run_once "foot" "foot --server"
run_once "gammastep" "gammastep -O 3500"
run_once "swaybg" "swaybg -i ~/sys/nix/desktop/wallpapers/wallpaper_girl_morgen.png"

if ! pgrep -f "wl-paste --watch cliphist store" >/dev/null; then
  niri msg action spawn-sh -- "wl-paste --watch cliphist store"
fi

if ! pgrep -f "batsignal" >/dev/null; then
  niri msg action spawn-sh -- "batsignal -w 10 -f 80"
fi

notify-send "Niri" "Init system done"
