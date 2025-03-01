{pkgs, ...}: {
  home.packages = with pkgs; [
    nerd-fonts.proggy-clean-tt

    killall
    tabbed
    unzip
    nh
    xclip
    wget
    ripgrep
    dmenu
    networkmanager_dmenu

    python312
    texlive.combined.scheme-full
  ];
}
