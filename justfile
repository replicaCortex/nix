run:
    nh os switch --ask /home/replica/dev/nix/nixos/ && dunstify "  NixOS" "Nix switch done 󰄬" || dunstify -u critical "  NixOS" "Home switch failed ❌" -t 4000

update-nvim:
    cd ./nixos && nix flake lock --update-input nixpkgs-neovim

update:
    cd ./nixos && nix flake update

sync:
    @mkdir -p ~/.var/.config
    @ln -sfn /etc/dunst $XDG_CONFIG_HOME/dunst
    @ln -sfn /etc/niri/ $XDG_CONFIG_HOME/niri
    @ln -sfn $DOTFILES/apps/mpv $XDG_CONFIG_HOME/mpv
    @ln -sfn $DOTFILES/apps/qutebrowser $XDG_CONFIG_HOME/qutebrowser
    @ln -sfn $DOTFILES/apps/zathura $XDG_CONFIG_HOME/zathura
    @ln -sfn $DOTFILES/desktop/waybar $XDG_CONFIG_HOME/waybar
    @ln -sfn $DOTFILES/desktop/xdg-desktop-portal-termfilechooser/ $XDG_CONFIG_HOME/xdg-desktop-portal-termfilechooser
    @ln -sfn $DOTFILES/desktop/xdg-desktop-portal/ $XDG_CONFIG_HOME/xdg-desktop-portal
    @ln -sfn $DOTFILES/editor/nvim $XDG_CONFIG_HOME/nvim
    @ln -sfn $DOTFILES/terminal/fish $XDG_CONFIG_HOME/fish
    @ln -sfn $DOTFILES/terminal/foot $XDG_CONFIG_HOME/foot
    @ln -sfn $DOTFILES/terminal/yt-dlp/ $XDG_CONFIG_HOME/yt-dlp
    ollama pull qwen2.5:0.5b

dev:
    distrobox-assemble create --file $DOTFILES/containers/distrobox.ini

# TODO: just to nix
install-mpv-scripts:
    #!/usr/bin/env bash
    curl -fsSL https://raw.githubusercontent.com/tomasklaen/uosc/HEAD/installers/unix.sh | bash -s -- $XDG_CONFIG_HOME/mpv
    curl -Lo $XDG_CONFIG_HOME/mpv/scripts/thumbfast.lua https://raw.githubusercontent.com/po5/thumbfast/master/thumbfast.lua
