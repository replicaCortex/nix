{pkgs, ...}: {
  programs.yazi = {
    enable = true;
  };

  home.packages = with pkgs; [
    bat
    file
    ffmpeg
    jq
    poppler_utils
    fd
    ripgrep
    fzf
    zoxide
    imagemagick
  ];
}
