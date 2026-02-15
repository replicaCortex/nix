{ pkgs, ... }:
{
  programs.niri.enable = true;
  services.displayManager.ly.enable = true;

  environment.systemPackages = with pkgs; [
    wayland
    waybar
    brightnessctl
    dunst
    # swaybg
    swww
    foot
  ];
}
