{
  pkgs ? import <nixpkgs> { },
}:

let
  python = pkgs.python312;
  pythonWithPackages = python.withPackages (
    ps: with ps; [
      pygobject3
      pycairo
    ]
  );
in

pkgs.stdenv.mkDerivation {
  pname = "pie";
  version = "0.0.1";

  src = ./.;

  nativeBuildInputs = [
    pkgs.makeWrapper
    pkgs.wrapGAppsHook3
    pkgs.gobject-introspection
  ];

  buildInputs = [
    pythonWithPackages
    pkgs.gtk3
    pkgs.gtk-layer-shell
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/pie
    cp main.py $out/share/pie/

    makeWrapper ${pythonWithPackages}/bin/python3 $out/bin/pie \
      --add-flags "$out/share/pie/main.py" \
      --prefix GI_TYPELIB_PATH : "${pkgs.gtk3}/lib/girepository-1.0" \
      --prefix GI_TYPELIB_PATH : "${pkgs.gtk-layer-shell}/lib/girepository-1.0"

    runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "Radial menu for Wayland";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "pie";
  };
}
