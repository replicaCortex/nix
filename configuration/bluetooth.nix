{ pkgs, ... }:
{
  hardware.bluetooth.enable = true;
  hardware.bluetooth.package = pkgs.bluez;

  hardware.bluetooth.settings = {
    General = {
      DiscoverableTimeout = 0;
    };
  };
}
