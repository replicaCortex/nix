{pkgs, ...}: {
  home.packages = with pkgs; [
    nerd-fonts.cousine
    nerd-fonts.jetbrains-mono

    flameshot
    ntfs3g
    unzip
    fzf
    xclip
    wget
    lazygit
    gcc
    ripgrep
    pylint
    dmenu

    #Global python pkgs
    python312
    thefuck
  ];
}
