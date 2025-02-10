{pkgs, ...}: {
  home.packages = with pkgs; [
    nerd-fonts.cousine
    tabbed
    # nerd-fonts.ubuntu
    # open-sans
    # arkpandora_ttf
    # nerd-fonts.jetbrains-mono
    # nerd-fonts.gohufont
    nerd-fonts.proggy-clean-tt
    # nerd-fonts.bigblue-terminal
    nerd-fonts.departure-mono
    # gohufont

    flameshot
    killall
    btop
    ntfs3g
    mpv
    unzip
    fzf
    xclip
    wget
    lazygit
    gcc
    ripgrep
    dmenu

    #Global python pkgs
    # python312Packages.pytest
    # python312
    # thefuck
  ];
}
