{pkgs, ...}: {
  home.packages = with pkgs; [
    nerd-fonts.ubuntu
    nerd-fonts.proggy-clean-tt

    killall
    tabbed
    ntfs3g
    unzip
    xclip
    wget
    ripgrep
    dmenu

    python312
  ];
}
