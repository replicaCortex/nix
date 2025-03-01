{pkgs, ...}: {
  home.packages = with pkgs; [
    nerd-fonts.proggy-clean-tt

    killall
    tabbed
    ntfs3g
    unzip
    nh
    xclip
    wget
    ripgrep
    dmenu
    texlive.combined.scheme-full
  ];
}
