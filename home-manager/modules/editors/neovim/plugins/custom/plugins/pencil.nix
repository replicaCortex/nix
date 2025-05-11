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
      vim.cmd [[
        augroup LazyProseMode
          autocmd!
          " при открытии markdown или plain text — подгрузить плагин
          autocmd FileType markdown,text packadd vim-pencil
        augroup END
      ]]

      -- после packadd вызываем setup плагина
      vim.api.nvim_create_autocmd({"FileType"}, {
        pattern = {"markdown","text"},
        callback = function()
          require("vim-pencil").setup()
        end
      })
    '';
  };
}
