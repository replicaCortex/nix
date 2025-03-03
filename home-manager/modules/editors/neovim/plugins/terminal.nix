{
  programs.nixvim = {
    # TODO: сделать автопрокруту без режима вставки
    extraConfigLuaPre = ''
      vim.api.nvim_create_autocmd("TermOpen", {
          pattern = "*",
          command = "setlocal nonumber norelativenumber"
      })

      vim.api.nvim_create_autocmd("BufEnter", {
          pattern = "term://*",
          callback = function()
            vim.cmd("startinsert")
          end,
      })


      function OpenSplitTermV()
          vim.cmd("vsplit term://zsh")
          vim.cmd("vertical resize 40")
          vim.cmd("startinsert")
      end

      function OpenSplitTermH()
          vim.cmd("split term://zsh")
          vim.cmd("resize 6")
          vim.cmd("startinsert")
      end

      vim.api.nvim_set_keymap("n", "<leader>|", "<cmd>lua OpenSplitTermV()<CR>", { noremap = true, silent = true })

      vim.api.nvim_set_keymap("n", "<leader>-", "<cmd>lua OpenSplitTermH()<CR>", { noremap = true, silent = true })

      vim.api.nvim_set_keymap("n", "<leader><A-|>", "<cmd>vsplit<CR>", { noremap = true, silent = true })

      vim.api.nvim_set_keymap("n", "<leader><A-->", "<cmd>split<CR>", { noremap = true, silent = true })

      vim.api.nvim_set_keymap("t", "<ESC>", "<C-\\><C-n>", { noremap = true, silent = true })

      vim.api.nvim_set_keymap("t", "<A-c>", "<C-\\><C-n><cmd>bdelete!<CR>", { noremap = true, silent = true })

      vim.api.nvim_set_keymap('t', '<C-h>', '<C-\\><C-n><C-w>h', { noremap = true, silent = true })
      -- vim.api.nvim_set_keymap('t', '<C-j>', '<C-\\><C-n><C-w>j', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('t', '<C-k>', '<C-\\><C-n><C-w>k', { noremap = true, silent = true })
      -- vim.api.nvim_set_keymap('t', '<C-l>', '<C-\\><C-n><C-w>l', { noremap = true, silent = true })

      vim.api.nvim_set_keymap('t', '<A-.>', '<C-\\><C-n><cmd>bnext<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('t', '<A-,>', '<C-\\><C-n><cmd>bprevious<CR>', { noremap = true, silent = true })

    '';
  };
}
