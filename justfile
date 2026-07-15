run:
    nh os switch --ask /home/replica/dev/nix/nixos/ && dunstify "  NixOS" "Nix switch done 󰄬" || dunstify -u critical "  NixOS" "Home switch failed ❌" -t 4000

update-nvim:
    cd ./nixos && nix flake lock --update-input nixpkgs-neovim

update:
    cd ./nixos && nix flake update

# TODO: rewrite to nixos
sync:
    @mkdir -p ~/.var/.config
    @ln -sfn $DOTFILES/apps/mpv $XDG_CONFIG_HOME/
    @ln -sfn $DOTFILES/apps/qutebrowser $XDG_CONFIG_HOME/
    @ln -sfn $DOTFILES/apps/zathura $XDG_CONFIG_HOME/
    @ln -sfn $DOTFILES/desktop/waybar $XDG_CONFIG_HOME/
    @ln -sfn $DOTFILES/desktop/xdg-desktop-portal-termfilechooser/ $XDG_CONFIG_HOME/
    @ln -sfn $DOTFILES/desktop/xdg-desktop-portal/ $XDG_CONFIG_HOME/
    @ln -sfn $DOTFILES/editor/nvim $XDG_CONFIG_HOME/
    @ln -sfn $DOTFILES/terminal/fish $XDG_CONFIG_HOME/
    @ln -sfn $DOTFILES/terminal/foot $XDG_CONFIG_HOME/
    @ln -sfn $DOTFILES/terminal/gallery-dl/ $XDG_CONFIG_HOME/
    @ln -sfn $DOTFILES/terminal/yt-dlp/ $XDG_CONFIG_HOME/
    @ln -sfn /etc/dunst $XDG_CONFIG_HOME/
    @ln -sfn /etc/niri/ $XDG_CONFIG_HOME/

# TODO: just to nix
install-mpv-scripts:
    #!/usr/bin/env bash
    curl -fsSL https://raw.githubusercontent.com/tomasklaen/uosc/HEAD/installers/unix.sh | bash -s -- $XDG_CONFIG_HOME/mpv
    curl -Lo $XDG_CONFIG_HOME/mpv/scripts/thumbfast.lua https://raw.githubusercontent.com/po5/thumbfast/master/thumbfast.lua
