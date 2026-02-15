{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      gnutar
      gzip
      unrar
      unzip
      zstd
    ];
  };
}
