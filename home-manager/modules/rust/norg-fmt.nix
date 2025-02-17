{pkgs, ...}: {
  home.packages = [
    (pkgs.rustPlatform.buildRustPackage {
      pname = "norg-fmt";
      version = "58d8b88";
      src = pkgs.fetchFromGitHub {
        owner = "nvim-neorg";
        repo = "norg-fmt";
        rev = "58d8b8804a48941ed599d9236d72f0f31956b563";
        sha256 = "GS8Ub1TMKvCyABXZLxasM9Uo/6ccpTyfrE0ZoiH5QKg=";
      };
      cargoLock = {
        lockFile = ./cargo.lock;
        outputHashes = {
          "rust-norg-0.1.0" = "SIAnp6W5O7tWBotI/jNU9mVdxmQcMTioFp5h+3E/9+Y=";
        };
      };
    })
  ];
}
