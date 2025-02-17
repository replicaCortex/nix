{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "jupytext";
        src = pkgs.fetchFromGitHub {
          owner = "GCBallesteros";
          repo = "jupytext.nvim";
          rev = "c8baf3ad344c59b3abd461ecc17fc16ec44d0f7b";
          hash = "sha256-LBBRZOSqn70qruSA/vbPMTzS7y05F/z4EqC+5JlU6NM=";
        };
      })
    ];
    extraConfigLuaPre = ''

      require("jupytext").setup({
          style = "markdown",
          output_extension = "md",
          force_ft = "markdown",
      })

    '';
    extraPackages = [(pkgs.python3.withPackages (p: [p.jupytext]))];
  };
}
