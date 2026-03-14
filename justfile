run:
    nh os switch --ask /home/replica/sys/nix/nixos/ && dunstify "  NixOS" "Nix switch done 󰄬" || dunstify -u critical -h string:fgcolor:#f38ba8 "  NixOS" "Home switch failed ❌" -t 4000

sync:
    @echo "🔗 Создаем симлинки в ~/.var/.config..."
    @mkdir -p ~/.var/.config
    @ln -sfn ~/sys/nix/terminal/fish $XDG_CONFIG_HOME/fish
    @ln -sfn ~/sys/nix/terminal/foot $XDG_CONFIG_HOME/foot
    @ln -sfn ~/sys/nix/terminal/broot $XDG_CONFIG_HOME/broot
    @ln -sfn ~/sys/nix/terminal/lsd $XDG_CONFIG_HOME/lsd
    @ln -sfn ~/sys/nix/desktop/niri $XDG_CONFIG_HOME/niri
    @ln -sfn ~/sys/nix/desktop/waybar $XDG_CONFIG_HOME/waybar
    @ln -sfn ~/sys/nix/desktop/dunst $XDG_CONFIG_HOME/dunst
    @ln -sfn ~/sys/nix/editor/nvim $XDG_CONFIG_HOME/nvim
    @ln -sfn ~/sys/nix/apps/mpv $XDG_CONFIG_HOME/mpv
    @ln -sfn ~/sys/nix/apps/vimiv $XDG_CONFIG_HOME/vimiv
    @ln -sfn ~/sys/nix/apps/zathura $XDG_CONFIG_HOME/zathura
    @echo "✅ Конфиги успешно синхронизированы!"

dev:
    @echo "🐳 Собираем Dev-контейнер..."
    distrobox-assemble create --file ~/sys/nix/containers/distrobox.ini
