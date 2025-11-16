# niri msg action spawn -- footclient --working-directory="$1" -- bash -c 'nix-shell --argstr mode server shell.nix && exec bash'
# sleep 0.2
# niri msg action move-column-left
# niri msg action focus-column-right
niri msg action spawn -- footclient --working-directory="$1" -- bash -c 'nix-shell shell.nix && exec bash'
sleep 0.2
niri msg action focus-column-left
niri msg action spawn -- footclient --working-directory="$1" -- bash -c 'nix-shell shell.nix && exec bash'
sleep 0.2
niri msg action move-column-left
niri msg action focus-column-right
niri msg action set-window-width 66.666667%
niri msg action focus-column-left

nix-shell shell.nix
