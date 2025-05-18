{pkgs, ...}: {
  programs.nixvim = {
    # extraPlugins = [
    # ];

    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "vim-pencil";
        src = pkgs.fetchFromGitHub {
          owner = "preservim";
          repo = "vim-pencil";
          # rev = "1a7d6b1dfb2f176715ccc9e838be32d044f8a734";
          tag = "1.6.1";
          hash = "sha256-CkUROC4vyIdNbRONCgOnuPky8pZXE25KHKU9icCqWKI=";
        };
      })

      pkgs.vimPlugins.no-neck-pain-nvim
    ];

    extraConfigLuaPre = ''
      -- NOTE что? not work))
      require("lz.n").load {
          {
              "pencil",
              cmd = "Pencil",
              after = function() require("pencil").setup({ }) end,
          },
          {
              "no-neck-pain-nvim",
              cmd = "NoNeckPain",
          },
      }
    '';
  };
}
