{pkgs, ...}: {
  programs.bat = {
    enable = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  home.packages = with pkgs; [
    nerd-fonts.proggy-clean-tt

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

    yad
    # xdotool

    # dmenu-rs-enable-plugins
    dmenu
    bemoji

    gnutar
    gzip
    unzip

    nsxiv
    jq

    ffmpeg-full
  ];
}
