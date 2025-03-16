{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "vim-ripgrep";
        src = pkgs.fetchFromGitHub {
          owner = "jremmen";
          repo = "vim-ripgrep";
          tag = "v1.0.3";
          sha256 = "OvQPTEiXOHI0uz0+6AVTxyJ/TUMg6kd3BYTAbnCI7W8=";
        };

        buildInputs = [
          pkgs.fzf
          pkgs.ripgrep
        ];
      })
    ];
  };
}
