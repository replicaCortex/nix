{ pkgs, ... }:
{
  programs.nix-ld.enable = true;

  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    glibc

    openssl
    libsodium
    libxcrypt
    libssh

    curl
    libxml2
    expat

    zlib
    zstd
    bzip2
    xz

    util-linux
    glib
    acl
    attr
    systemd

    libGL
    libxkbcommon

    SDL2
  ];
}
