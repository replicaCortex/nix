{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "norg-fmt";
        src = pkgs.fetchFromGitHub {
          owner = "nvim-neorg";
          repo = "norg-fmt";
          rev = "58d8b8804a48941ed599d9236d72f0f31956b563";
          sha256 = "GS8Ub1TMKvCyABXZLxasM9Uo/6ccpTyfrE0ZoiH5QKg=";
        };
      })
    ];
  };
}
