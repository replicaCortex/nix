{
  programs.nixvim = {
    plugins.nvim-surround = {
      enable = true;
    };
    extraConfigLuaPre = ''
      require("nvim-surround").setup({
        surrounds = {
          ["l"] = {
            add = function()
              local ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
              local clipboard = vim.fn.getreg("+")
              if ft == "norg" then
                return { { ("{%s}["):format(clipboard) }, { "]" } }
              end
              return { { "[" }, { "](" .. clipboard .. ")" } }
            end,
            find = function()
              local config = require("nvim-surround.config")
              local ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
              if ft == "norg" then
                return config.get_selection({ node = "link" })
              end
              return config.get_selection({ node = "inline_link" })
            end,
            delete = "(%[)().-(%]%(.-%))()",
          },
        },
      })
    '';
  };
}
