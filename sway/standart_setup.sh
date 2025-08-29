swaymsg splith
swaymsg exec "footclient --working-directory='$(swaycwd)'"
sleep 0.2
swaymsg splitv
swaymsg layout stacking
swaymsg focus left
swaymsg resize grow width 180px
swaymsg splitv
swaymsg layout stacking
