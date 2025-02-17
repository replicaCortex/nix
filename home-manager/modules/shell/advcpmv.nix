{pkgs, ...}: let
  nixpkgs_23_11 =
    import (fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/nixos-23.11.tar.gz";
      sha256 = "1f5d2g1p6nfwycpmrnnmc2xmcszp804adp16knjvdkj8nz36y1fg";
    }) {
      system = "x86_64-linux";
    };
  advcpmv = (nixpkgs_23_11.coreutils.override {singleBinary = false;}).overrideAttrs (
    old: let
      advcpmv-data = {
        pname = "advcpmv";
        patch-version = "0.9";
        coreutils-version = "9.3";
        version = "${advcpmv-data.patch-version}-${advcpmv-data.coreutils-version}";
        src = nixpkgs_23_11.fetchFromGitHub {
          owner = "jarun";
          repo = "advcpmv";
          rev = "a1f8b505e691737db2f7f2b96275802c45f65c59";
          hash = "sha256-IHfMu6PyGRPc87J/hbxMUdosmLq13K0oWa5fPLWKOvo=";
        };
        patch-file = advcpmv-data.src + "/advcpmv-${advcpmv-data.version}.patch";
      };
    in
      assert (advcpmv-data.coreutils-version == old.version); {
        inherit (advcpmv-data) pname version;

        patches =
          (old.patches or [])
          ++ [
            advcpmv-data.patch-file
          ];

        configureFlags =
          (old.configureFlags or [])
          ++ [
            "--program-prefix=adv"
          ];

        postInstall =
          (old.postInstall or [])
          + ''
            pushd $out/bin
            ln -s advcp cpg
            ln -s advmv mvg
            popd
          '';

        meta =
          old.meta
          // {
            description = "Coreutils patched to add progress bars";
          };
      }
  );
in {
  home.packages = [advcpmv];
}
