run:
    nh os switch --ask /home/replica/sys/nix/nixos/ && dunstify "  NixOS" "Nix switch done 󰄬" || dunstify -u critical "  NixOS" "Home switch failed ❌" -t 4000

update-nvim:
    cd ./nixos && nix flake lock --update-input nixpkgs-neovim

update:
    cd ./nixos && nix flake update

sync:
    @mkdir -p ~/.var/.config
    @ln -sfn /etc/dunst $XDG_CONFIG_HOME/dunst
    @ln -sfn /etc/niri/ $XDG_CONFIG_HOME/niri
    @ln -sfn ~/sys/nix/apps/mpv $XDG_CONFIG_HOME/mpv
    @ln -sfn ~/sys/nix/apps/qutebrowser $XDG_CONFIG_HOME/qutebrowser
    @ln -sfn ~/sys/nix/apps/zathura $XDG_CONFIG_HOME/zathura
    @ln -sfn ~/sys/nix/desktop/waybar $XDG_CONFIG_HOME/waybar
    @ln -sfn ~/sys/nix/desktop/xdg-desktop-portal-termfilechooser/ $XDG_CONFIG_HOME/xdg-desktop-portal-termfilechooser
    @ln -sfn ~/sys/nix/desktop/xdg-desktop-portal/ $XDG_CONFIG_HOME/xdg-desktop-portal
    @ln -sfn ~/sys/nix/editor/nvim $XDG_CONFIG_HOME/nvim
    @ln -sfn ~/sys/nix/terminal/fish $XDG_CONFIG_HOME/fish
    @ln -sfn ~/sys/nix/terminal/foot $XDG_CONFIG_HOME/foot
    @ln -sfn ~/sys/nix/terminal/yt-dlp/ $XDG_CONFIG_HOME/yt-dlp

dev:
    distrobox-assemble create --file ~/sys/nix/containers/distrobox.ini
