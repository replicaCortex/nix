{
  appimageTools,
  fetchurl,
  ...
}: let
  pname = "zen";
  version = "latest";

  src = fetchurl {
    url = "https://github.com/zen-browser/desktop/releases/latest/download/zen-x86_64.AppImage";
    sha256 = "sha256-Uc4Jw0+SANRYj11xr42ULiyxX31Q2Ba7cQWstRF9Uw8=";
  };
in
  appimageTools.wrapType2 {
    inherit pname version src;

    meta = {
      platforms = ["x86_64-linux"];
    };
  }
