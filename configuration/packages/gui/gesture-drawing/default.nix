{
  pkgs ? import <nixpkgs> { },
}:

let
  python = pkgs.python312;
  pythonWithPackages = python.withPackages (
    ps: with ps; [
      pyqt6
      pygame
    ]
  );
in

pkgs.stdenv.mkDerivation {
  pname = "gesture-drawing";
  version = "0.0.1";

  src = ./.;

  nativeBuildInputs = [
    pkgs.makeWrapper
    pkgs.qt6.wrapQtAppsHook
  ];

  buildInputs = [
    pythonWithPackages
    pkgs.qt6.qtbase
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/gesture-drawing
    cp main.py $out/share/gesture-drawing/
    cp -r *.json $out/share/gesture-drawing/ 2>/dev/null || true

    makeWrapper ${pythonWithPackages}/bin/python3 $out/bin/gesture-drawing \
      --add-flags "$out/share/gesture-drawing/main.py" \
      --set QT_QPA_PLATFORM_PLUGIN_PATH "${pkgs.qt6.qtbase}/lib/qt-6/plugins/platforms" \
      --prefix QT_PLUGIN_PATH : "${pkgs.qt6.qtbase}/lib/qt-6/plugins"

    runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "Gesture Drawing Practice App";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "gesture-drawing";
  };
}
