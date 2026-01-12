# nix switch done
nrs: ni
    nh os switch --ask /home/replica/nix/ && dunstify "  NixOS" "Nix switch done 󰄬" || dunstify -u critical -h string:fgcolor:#f38ba8 "  NixOS" "Home switch failed ❌" -t 4000

# nix-instantiate
ni:
    nix-instantiate --parse /home/replica/nix/**/*.nix > /dev/null 

# nix-collect-garbage
ncg:
    nix-collect-garbage
    nix-store --optimise

install_config:
    rm -rf ~/.config/dunst
    rm -rf ~/.config/fish
    rm -rf ~/.config/foot
    rm -rf ~/.config/lsd
    rm -rf ~/.config/mpv
    rm -rf ~/.config/niri
    rm -rf ~/.config/nvim
    rm -rf ~/.config/broot
    rm -rf ~/.config/vimiv
    rm -rf ~/.config/waybar
    rm -rf ~/.config/zathura
    rm -rf ~/.config/xdg-desktop-portal-termfilechooser
    rm -rf ~/.config/xdg-desktop-portal
    rm ~/.inputrc
    rm ~/.zen/**Default*/chrome/userChrome.css

    ln -s ~/nix/.inputrc ~/
    ln -s ~/nix/dunst ~/.config/
    ln -s ~/nix/xdg-desktop-portal-termfilechooser/ ~/.config/
    ln -s ~/nix/xdg-desktop-portal/ ~/.config/
    ln -s ~/nix/fish ~/.config/
    ln -s ~/nix/foot ~/.config/
    ln -s ~/nix/lsd ~/.config/
    ln -s ~/nix/mpv ~/.config/
    ln -s ~/nix/broot/ ~/.config/
    ln -s ~/nix/niri ~/.config/
    ln -s ~/nix/nvim ~/.config/
    ln -s ~/nix/vimiv ~/.config/
    ln -s ~/nix/waybar ~/.config/
    ln -s ~/nix/zathura ~/.config/
    ln -s ~/nix/zen/userChrome.css ~/.zen/**Default*/chrome/

# fast up commit
fup: fmt
    git add .
    git commit -m "up"
    git push

fmt:
    @alejandra . > /dev/null
    @stylua . > /dev/null
    @mdformat --wrap 80 . > /dev/null
    @fixjson *.json > /dev/null 2>&1 || true
    @fish-lsp . > /dev/null
