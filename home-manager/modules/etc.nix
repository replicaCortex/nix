{pkgs, ...}: {
  home.packages = with pkgs; [
    nerd-fonts.cousine
    nerd-fonts.jetbrains-mono
    # nerd-fonts.gohufont
    # nerd-fonts.departure-mono
    # gohufont

    flameshot
    killall
    # btop
    ntfs3g
    # unzip
    fzf
    xclip
    wget
    lazygit
    # gcc
    ripgrep
    dmenu

    #Global python pkgs
    # python312
    # thefuck
  ];
}
