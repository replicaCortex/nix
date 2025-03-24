{pkgs, ...}: {
  home.packages = with pkgs; [
    nerd-fonts.proggy-clean-tt

    killall
    ntfs3g
    delta
    unzip
    nh
    xclip
    wget
    ripgrep
    dmenu
    texlive.combined.scheme-full
  ];
}
