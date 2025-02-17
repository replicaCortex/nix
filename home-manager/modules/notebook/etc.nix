{pkgs, ...}: {
  home.packages = with pkgs; [
    nerd-fonts.cousine
    nerd-fonts.proggy-clean-tt

    killall
    tabbed
    unzip
    xclip
    wget
    ripgrep
    dmenu
    networkmanager_dmenu

    # python312
  ];
}
