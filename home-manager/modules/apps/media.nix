{pkgs, ...}: {
  programs.feh = {
    enable = true;
    #themes.feh = ["--image-bg"];
  };

  programs.zathura = {
    enable = true;
  };

  programs.mpv = {
    enable = true;
  };

  programs.obs-studio = {
    enable = true;
  };

  home.packages = with pkgs; [escrotum];
}
