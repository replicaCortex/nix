{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    hyprpaper
    wl-clipboard
    cliphist
    hyprsunset
    hyprshot
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.waybar = {
    enable = true;
  };
}
