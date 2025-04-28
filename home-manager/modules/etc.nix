{pkgs, ...}: {
  programs.bat = {
    enable = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  home.packages = with pkgs; [
    # font
    nerd-fonts.proggy-clean-tt
    nerd-fonts.ubuntu
    times-newer-roman

    killall
    # xdg-utils
    ntfs3g
    # delta
    nh
    xclip
    wget
    ripgrep

    libreoffice
    networkmanager_dmenu

    python312
    texlive.combined.scheme-full
    python312Packages.catppuccin

    dmenu
    bemoji

    gnutar
    gzip
    unzip

    nsxiv
    jq

    ffmpeg-full

    xdragon
    xdotool

    file
  ];
}
