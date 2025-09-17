swaymsg splith
swaymsg exec "footclient --working-directory='$1' -- bash -c 'cd build/ && nix-shell ../shell.nix --argstr mode cmake && exec bash'"
sleep 0.2
swaymsg focus left
swaymsg splitv
swaymsg exec "footclient --working-directory='$1' -- bash -c 'cd build/ && nix-shell ../shell.nix --argstr mode cmake && exec bash'"
sleep 0.2
swaymsg resize shrink height 340px
swaymsg resize grow width 180px
swaymsg focus right
swaymsg splitv
swaymsg layout stacking
swaymsg focus left
swaymsg focus up
swaymsg splith
swaymsg exec "footclient --working-directory='$1' -- bash -c 'cd src/ && nix-shell ../shell.nix && exec bash'"
sleep 0.2
# самый левый тайл
swaymsg resize grow width 220px
swaymsg focus right

cd "$1/src/" && nix-shell ../shell.nix
