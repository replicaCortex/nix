{
  programs.nixvim = {
    extraFiles = {
      "ftplugin/markdown.lua".text = ''
        vim.opt.tabstop = 2
        vim.opt.shiftwidth = 2
        vim.opt.expandtab = true

        vim.opt_local.conceallevel = 2

        vim.keymap.set({ "o", "x" }, "il", "<cmd>lua require('various-textobjs').mdlink('inner')<CR>", { buffer = true })
        vim.keymap.set({ "o", "x" }, "al", "<cmd>lua require('various-textobjs').mdlink('outer')<CR>", { buffer = true })
      '';

      "ftplugin/norg.lua".text = ''
        vim.opt.tabstop = 2
        vim.opt.shiftwidth = 2
        vim.opt.expandtab = true

        vim.opt_local.conceallevel = 2
        vim.opt_local.concealcursor = "nc"
        vim.bo.comments = vim.bo.comments:gsub("n:>,?", "")
      '';

      "ftplugin/nix.lua".text = ''
        vim.opt.tabstop = 2
        vim.opt.shiftwidth = 2
        vim.opt.expandtab = true
      '';

      "ftplugin/text.lua".text = ''
        vim.opt.tabstop = 2
        vim.opt.shiftwidth = 2
        vim.opt.expandtab = true
      '';

      "ftplugin/tex.lua".text = ''
        vim.opt.tabstop = 2
        vim.opt.shiftwidth = 2
        vim.opt.expandtab = true

        vim.opt_local.conceallevel = 2
        vim.opt.concealcursor = 'c'
      '';
    };
  };
}
