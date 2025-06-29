{pkgs, ...}: {
  programs.sway.enable = true;

  environment.systemPackages = with pkgs; [
    waybar
    brightnessctl
    dunst
    swaycwd
  ];
}
