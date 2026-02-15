{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  buildInputs = with pkgs; [
    python312Packages.pyinstaller
    python312Packages.pyqt6
    python312Packages.pygame
  ];

  shellHook = "";
}
