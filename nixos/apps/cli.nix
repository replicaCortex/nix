{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    distrobox

    gitMinimal
    bat
    broot
    btop
    fd
    fzf
    jq
    lsd
    ripgrep
    zstd
    unzip
    file

    chafa
    imagemagick
  ];
}
