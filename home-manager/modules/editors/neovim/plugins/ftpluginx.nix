{
  programs.nixvim = {
    extraFiles = {
      "ftplugin/markdown.lua".text = ''
         vim.opt.tabstop = 2
         vim.opt.shiftwidth = 2
         vim.opt.expandtab = true

         -- require("render-markdown").setup({
         --   custom = {
         --     important = {
         --       raw = "[_]",
         --       rendered = "󰩹 ",
         --     },
         --   },
         -- })

        -- file: nvim/ftplugin/markdown.lua
        -- require("quarto").activate()
        -- require("otter").activate()

      '';

      # "ftplugin/norg.lua".text = ''
      #   vim.opt.tabstop = 4
      #   vim.opt.shiftwidth = 4
      #   vim.opt.expandtab = true
      #
      #   vim.opt_local.conceallevel = 2
      #   vim.opt_local.concealcursor = "nc"
      #   vim.bo.comments = vim.bo.comments:gsub("n:>,?", "")
      # '';

      # "ftplugin/lua.lua".text = ''
      #   vim.opt.tabstop = 2
      #   vim.opt.shiftwidth = 2
      #   vim.opt.expandtab = true
      # '';
      #
      # "ftplugin/cs.lua".text = ''
      #   vim.opt.tabstop = 4
      #   vim.opt.shiftwidth = 4
      #   vim.opt.expandtab = true
      # '';
      #
      # "ftplugin/nix.lua".text = ''
      #   vim.opt.tabstop = 2
      #   vim.opt.shiftwidth = 2
      #   vim.opt.expandtab = true
      # '';
      #
      # "ftplugin/c.lua".text = ''
      #   vim.opt.tabstop = 2
      #   vim.opt.shiftwidth = 2
      #   vim.opt.expandtab = true
      # '';
      #
      # "ftplugin/text.lua".text = ''
      #   vim.opt.tabstop = 2
      #   vim.opt.shiftwidth = 2
      #   vim.opt.expandtab = true
      # '';
      #
      # "ftplugin/tex.lua".text = ''
      #   vim.opt.tabstop = 2
      #   vim.opt.shiftwidth = 2
      #   vim.opt.expandtab = true
      #   vim.opt_local.conceallevel = 1
      # '';
    };
  };
}
