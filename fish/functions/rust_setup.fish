function rust_setup
    set path $PWD

    niri msg action spawn -- footclient --working-directory=$path
    sleep 0.2
    niri msg action focus-column-left
    niri msg action spawn -- footclient --working-directory=$path
    sleep 0.2
    niri msg action move-column-left
    niri msg action focus-column-right
    niri msg action set-window-width 66.666667%
    niri msg action focus-column-left
end
