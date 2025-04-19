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

  home.packages = with pkgs; [maim];
}
