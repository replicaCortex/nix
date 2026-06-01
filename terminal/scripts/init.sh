function run_once {
  if ! pgrep -f "$1" >/dev/null; then
    niri msg action spawn-sh -- "${2:-$1}"
  fi
}

run_once "dunst"
run_once "waybar"

run_once "foot" "foot --server"
run_once "gammastep" "gammastep -O 3500"
run_once "swaybg" "swaybg -i ~/sys/nix/desktop/wallpapers/untitled.png"

if ! pgrep -f "wl-paste --watch cliphist -max-items 2000 -min-store-length 5 store" >/dev/null; then
  niri msg action spawn-sh -- "wl-paste --watch cliphist -max-items 2000 -min-store-length 5 store"
fi

if ! pgrep -f "batsignal" >/dev/null; then
  niri msg action spawn-sh -- "batsignal -w 10 -f 80"
fi

if ! pgrep -f "niri-float-sticky" >/dev/null; then
  niri msg action spawn-sh -- "niri-float-sticky"
fi

notify-send "Niri" "Init system done"
