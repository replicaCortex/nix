{
  imports = [
    # apps
    ./apps/media.nix
    ./apps/utils.nix
    ./apps/browsers.nix

    # windowManagers
    # ./windowManagers/sway.nix
    # ./windowManagers/hyprland.nix

    # shell
    ./shell/bash.nix
    ./shell/fuzzel.nix
    ./shell/zellij.nix
    # ./shell/tmux.nix

    # terminal
    # ./terminals/wezterm.nix
    ./terminals/foot.nix

    # editors
    ./editors/neovim/nixvim.nix
    ./editors/krita.nix
    # ./editors/euporie.nix

    # services
    # ./services/clipmenu.nix
    ./services/redshift.nix
    ./services/dunst.nix

    # TSobject
    # ./editors/neovim/plugins/custom/plugins/TSObjects/textobjects.nix
    # ../../static/bemoji/bemoji.nix

    # etc
    ./etc.nix
  ];
}
