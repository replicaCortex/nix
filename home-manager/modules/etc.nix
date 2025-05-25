{pkgs, ...}: {
  programs.bat = {
    enable = true;
  };

  programs.fzf = {
    enable = true;
  };

  services.podman = {
    enable = true;
    settings = {
      policy = {
        default = [
          {type = "insecureAcceptAnything";}
        ];
        transports = {
          docker = {
            "docker.io" = [
              {type = "insecureAcceptAnything";}
            ];
            "quay.io" = [
              {type = "insecureAcceptAnything";}
            ];
          };
        };
      };
    };
  };

  home.packages = with pkgs; [
    # font
    nerd-fonts.ubuntu
    ubuntu_font_family
    times-newer-roman

    ntfs3g
    nh
    wget
    ripgrep

    libreoffice
    texlive.combined.scheme-full

    gnutar
    gzip
    unzip

    ffmpeg-full

    file

    vimiv-qt

    telegram-desktop
    xdragon
    # python312
  ];

  # home.file.vimiv_keys = {
  #   source = ../../static/vimiv/keys.conf;
  #   target = ".config/vimiv/keys.config";
  # };
  #
  # home.file.vimiv = {
  #   source = ../../static/vimiv/vimiv.conf;
  #   target = ".config/vimiv/vimiv.conf";
  # };
  #
  # home.file.vimiv_cat = {
  #   source = ../../static/vimiv/styles/catppuccine_mocha;
  #   target = ".config/vimiv/styles/catppuccine_mocha";
  # };

  home.file.vimiv = {
    source = ../../static/vimiv;
    target = ".config/vimiv";
  };
}
