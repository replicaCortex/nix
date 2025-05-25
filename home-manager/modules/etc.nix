{pkgs, ...}: {
  programs.bat = {
    enable = true;
  };

  programs.fzf = {
    enable = true;
  };

  # xresources.properties = {
  #   "Nsxiv.window.background" = "#1e1e2e";
  #   "Nsxiv.bar.foreground" = "#cdd6f4";
  #   "Nsxiv.window.foreground" = "#cdd6f4";
  # };

  home.packages = with pkgs; [
    # font
    ntfs3g
    nh
    xclip
    ripgrep

    # texlive.combined.scheme-full

    dmenu

    gnutar
    gzip
    unzip

    jq

    xdragon

    file

    python312
  ];
}
