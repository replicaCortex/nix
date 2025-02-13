{pkgs, ...}: {
  home.packages = with pkgs; [
    nerd-fonts.cousine
    tabbed
    nerd-fonts.proggy-clean-tt

    killall
    tabbed
    btop
    mpv
    unzip
    fzf
    xclip
    wget
    lazygit
    ripgrep
    dmenu
  ];
}
