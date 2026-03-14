{ pkgs, ... }:
{
  programs.niri.enable = true;
  services.displayManager.emptty.enable = true;

  environment.systemPackages = with pkgs; [
    waybar
    brightnessctl
    dunst
    swaybg
    foot
    wl-clipboard
    cliphist
  ];
}
