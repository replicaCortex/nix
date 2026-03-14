# nix switch done
run: ni
    nh os switch --ask /home/replica/sys/nix/ && dunstify "  NixOS" "Nix switch done 󰄬" || dunstify -u critical -h string:fgcolor:#f38ba8 "  NixOS" "Home switch failed ❌" -t 4000

# nix-instantiate
ni:
    nix-instantiate --parse ./configuration/**/*.nix > /dev/null 

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

    ln -s ~/sys/nix/.inputrc ~/
    ln -s ~/sys/nix/dunst ~/.config/
    ln -s ~/sys/nix/xdg-desktop-portal-termfilechooser/ ~/.config/
    ln -s ~/sys/nix/xdg-desktop-portal/ ~/.config/
    ln -s ~/sys/nix/fish ~/.config/
    ln -s ~/sys/nix/foot ~/.config/
    ln -s ~/sys/nix/lsd ~/.config/
    ln -s ~/sys/nix/mpv ~/.config/
    ln -s ~/sys/nix/broot/ ~/.config/
    ln -s ~/sys/nix/niri ~/.config/
    ln -s ~/sys/nix/nvim ~/.config/
    ln -s ~/sys/nix/vimiv ~/.config/
    ln -s ~/sys/nix/waybar ~/.config/
    ln -s ~/sys/nix/zathura ~/.config/
    ln -s ~/sys/nix/zen/userChrome.css ~/.zen/**Default*/chrome/

# fast up commit
fup:
    git add .
    git commit -m "up"
    git push
