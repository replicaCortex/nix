{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  buildInputs = with pkgs; [
    gtk3
    gtk-layer-shell

    python312Packages.pygobject3

    zlib
    gcc
    zstd
  ];

  LD_LIBRARY_PATH = "${pkgs.zlib}/lib:$LD_LIBRARY_PATH:${pkgs.stdenv.cc.cc.lib.outPath}/lib:$LD_LIBRARY_PATH";

  shellHook = "";
}
