swaymsg splith
swaymsg exec "footclient --title=exploer --working-directory='$1' -- bash -c 'nix-shell'"
sleep 0.2
swaymsg focus left
swaymsg splitv
swaymsg exec "footclient --title=preview --working-directory='$1' -- bash -c 'nix-shell --argstr mode preview'"
sleep 0.2
swaymsg splitv
swaymsg exec "footclient --title=render --working-directory='$1' -- bash -c 'nix-shell'"
sleep 0.2
swaymsg splith
swaymsg focus up
swaymsg move down
swaymsg resize shrink height 340px
swaymsg focus right
swaymsg focus up
swaymsg resize grow width 180px
swaymsg focus left
swaymsg splitv
swaymsg layout stacking

cd "$1" && nix-shell shell.nix
