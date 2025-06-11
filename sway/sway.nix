{pkgs, ...}: {
  programs.sway.enable = true;

  environment.systemPackages = with pkgs; [
    waybar
    sway-launcher-desktop
    brightnessctl
    dunst
    swaycwd
  ];
}
