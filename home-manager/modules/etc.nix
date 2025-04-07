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
    texlive.combined.scheme-full

    yad
    xdotool

    # dmenu-rs-enable-plugins
    dmenu
    bemoji
    python312
  ];
}
