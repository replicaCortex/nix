{pkgs, ...}: {
  home.packages = with pkgs; [
    nerd-fonts.cousine
    # nerd-fonts.ubuntu
    # open-sans
    # arkpandora_ttf
    # nerd-fonts.jetbrains-mono
    # nerd-fonts.gohufont
    nerd-fonts.proggy-clean-tt
    # nerd-fonts.bigblue-terminal
    # nerd-fonts.departure-mono
    # gohufont

    killall
    tabbed
    btop
    # ntfs3g
    mpv
    unzip
    fzf
    xclip
    wget
    lazygit
    ripgrep
    dmenu
    networkmanager_dmenu

    #Global python pkgs
    # python312Packages.pytest
    # python312
    # thefuck
  ];
}
