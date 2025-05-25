{pkgs, ...}: {
  programs.bat = {
    enable = true;
  };

  programs.fzf = {
    enable = true;
  };

  xresources.properties = {
    "Nsxiv.window.background" = "#1e1e2e";
    "Nsxiv.bar.foreground" = "#cdd6f4";
    "Nsxiv.window.foreground" = "#cdd6f4";
  };

  home.packages = with pkgs; [
    # font
    nerd-fonts.proggy-clean-tt
    nerd-fonts.ubuntu
    ubuntu_font_family
    times-newer-roman

    ntfs3g
    nh
    xclip
    wget
    ripgrep

    libreoffice
    texlive.combined.scheme-full

    dmenu

    gnutar
    gzip
    unzip

    nsxiv

    ffmpeg-full

    xdragon

    file

    telegram-desktop
    # python312
    killall
    nurl
    picom
  ];
}
