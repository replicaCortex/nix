install_config:
    rm -rf ~/.config/fish
    rm -rf ~/.config/lsd
    rm -rf ~/.config/nvim
    rm -rf ~/.config/broot
    rm -rf ~/.config/fastfetch

    ln -s ~/nix/fish ~/.config/
    ln -s ~/nix/fastfetch/ ~/.config/
    ln -s ~/nix/lsd ~/.config/
    ln -s ~/nix/broot/ ~/.config/
    ln -s ~/nix/nvim ~/.config/

# fast up commit
fup:
    git add .
    git commit -m "up"
    git push
