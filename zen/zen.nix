{
  appimageTools,
  fetchurl,
  ...
}: let
  pname = "zen";
  version = "latest";

  src = fetchurl {
    url = "https://github.com/zen-browser/desktop/releases/latest/download/zen-x86_64.AppImage";
    sha256 = "sha256-kDXEhZIRAvd/36o3U2IA/XzmHsmuj2lMD0cpEd8YLL0=";
  };

  desktopSrc = ./.;
in
  appimageTools.wrapType2 {
    inherit pname version src;

    meta = {
      platforms = ["x86_64-linux"];
    };
  }
