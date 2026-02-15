{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      prettier
      ruff
      rustfmt
      shfmt
      stylua
      taplo
    ];
  };
}
