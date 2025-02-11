{
  programs.nixvim = {
    colorschemes.catppuccin = {
      enable = true;
      lazyLoad.enable = true;
    };
    plugins.lz-n = {
      enable = true;
    };
    extraConfigLuaPre = ''
      require("lz.n").load {
        {
          "leetcode.nvim",
          cmd = "Leet",
          after = function()
              require("Leetcode").setup()
            end,
        },
        {
            "vim-startuptime",
            cmd = "StartupTime",
            before = function()
                -- Configuration for plugins that don't force you to call a `setup` function
                -- for initialization should typically go in a `before`
                --- or `beforeAll` function.
                vim.g.startuptime_tries = 10
            end,
        },
        {
            "image.nvim",
            ft = "markdown",
        },

        }

    '';
  };
}
