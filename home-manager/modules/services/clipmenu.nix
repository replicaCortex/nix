{pkgs, ...}: {
  home.packages = with pkgs; [clipmenu];

  services.clipmenu.launcher = "dmenu";
}
