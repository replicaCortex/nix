{ pkgs, ... }:
{
  hardware.opentabletdriver.enable = true;

  environment = {
    systemPackages = with pkgs; [
      gimp
      krita
      beeref
    ];
  };
}
