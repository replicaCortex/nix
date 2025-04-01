{pkgs, ...}: {
  home.packages = with pkgs; [
    nerd-fonts.proggy-clean-tt

    killall
    xdg-utils
    ntfs3g
    delta
    nh
    xclip
    wget
    ripgrep
    libreoffice
    dmenu
    texlive.combined.scheme-full
  ];
}
