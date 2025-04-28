{
  programs.nixvim = {
    extraConfigLuaPre = ''
      vim.cmd("source ~/.config/nvim/autoload/floaterm/wrapper/rg.vim")
    '';
    keymaps = [
      {
        mode = "n";
        key = "<leader>fw";
        action = "<CMD>FloatermNew rg<CR>";
        options = {
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>ац";
        action = "<CMD>FloatermNew rg<CR>";
        options = {
          silent = true;
        };
      }

      {
        mode = "n";
        key = "/";
        action = "<CMD>FloatermNew rgf<CR>";
        options = {
          silent = true;
        };
      }

      {
        mode = "n";
        key = ".";
        action = "<CMD>FloatermNew rgf<CR>";
        options = {
          silent = true;
        };
      }
    ];
  };
  home.file = {
    "/.config/nvim/autoload/floaterm/wrapper/rg.vim" = {
      source = ./rg.vim;
    };
  };
}
