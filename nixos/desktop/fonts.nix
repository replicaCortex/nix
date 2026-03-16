{ pkgs, ... }:
{
  fonts = {
    fontconfig.antialias = false;
    packages = with pkgs; [
      nerd-fonts.ubuntu
      ubuntu-classic
    ];
  };
}
