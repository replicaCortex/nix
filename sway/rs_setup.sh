swaymsg splith
# дебаг тайл
swaymsg exec "footclient --title='debug' --working-directory='$1' -- bash -c 'nix-shell shell.nix && exec bash'"
sleep 0.2
swaymsg splitv
swaymsg exec "footclient --title='server' --working-directory='$1' -- bash -c 'nix-shell --argstr mode server shell.nix && exec bash'"
sleep 0.2
swaymsg focus up
swaymsg layout tabbed
swaymsg focus left
swaymsg splitv
swaymsg exec "footclient --title='terminal' --working-directory='$1' -- bash -c 'nix-shell shell.nix && exec bash'"
sleep 0.2
swaymsg resize shrink height 340px
swaymsg resize grow width 180px
swaymsg focus right
swaymsg splitv
swaymsg layout stacking
swaymsg focus left
swaymsg focus up
swaymsg splith
# самый левый тайл
swaymsg exec "footclient --title='sub' --working-directory='$1' -- bash -c 'cd src/ && nix-shell ../shell.nix && exec bash'"
sleep 0.2
swaymsg resize grow width 220px
swaymsg focus right

cd "$1/src/" && nix-shell ../shell.nix
