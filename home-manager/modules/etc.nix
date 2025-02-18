{pkgs, ...}: {
  home.packages = with pkgs; [
    nerd-fonts.ubuntu
    nerd-fonts.proggy-clean-tt

    killall
    tabbed
    unzip
    xclip
    wget
    ripgrep
    dmenu

    python312
  ];
}
