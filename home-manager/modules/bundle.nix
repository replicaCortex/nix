{
  imports = [
    # apps
    ./apps/media.nix
    ./apps/utils.nix
    ./apps/browsers.nix

    # windowManagers
    ./windowManagers/bspwm.nix
    ./windowManagers/sxhkd.nix
    ./windowManagers/polybar.nix

    # shell
    ./shell/nnn.nix
    ./shell/tmux.nix
    ./shell/atac.nix
    ./shell/advcpmv.nix

    # terminal
    ./terminals/alacritty.nix

    # editors
    ./editors/neovim/nixvim.nix
    ./editors/krita.nix

    # services
    ./services/picom.nix
    ./services/clipmenu.nix
    ./services/redshift.nix
    ./services/dunst.nix

    # TSobject
    ./editors/neovim/plugins/custom/plugins/TSObjects/textobjects.nix

    # etc
    ./etc.nix
  ];
}
