{
  programs.nixvim = {
    # TODO: сделать автопрокруту без режима вставки

    # TODO: Повиксить растягивание

    # TODO: Убрать полное открывание терминала при удалении buf
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



      -- function OpenSplitTermV()
      --     local width = math.floor(vim.o.columns * 0.2)
      --     vim.cmd("vsplit term://zsh")
      --     vim.cmd("vertical resize " .. width)
      --     vim.cmd("startinsert")
      -- end


      function OpenSplitTermV()
          local buf = vim.api.nvim_create_buf(false, true)
          vim.cmd("vsplit")
          vim.api.nvim_win_set_buf(0, buf)
          vim.fn.termopen("zsh")
          vim.cmd("vertical resize " .. math.floor(vim.o.columns * 0.2))
          vim.cmd("startinsert")
      end

      function OpenSplitTermH()
          local buf = vim.api.nvim_create_buf(false, true)
          vim.cmd("split")
          vim.api.nvim_win_set_buf(0, buf)
          vim.fn.termopen("zsh")
          vim.cmd("resize 10")
          vim.cmd("startinsert")
      end

      function OpenNewBufTerm()
          local buf = vim.api.nvim_create_buf(true, false)
          vim.api.nvim_set_current_buf(buf)
          vim.fn.termopen("zsh")
          vim.cmd("startinsert")
      end

      vim.api.nvim_set_keymap("n", "<leader>nt", "<cmd>lua OpenNewBufTerm()<CR>", { noremap = true, silent = true })

      vim.api.nvim_set_keymap("n", "<leader>|", "<cmd>lua OpenSplitTermV()<CR>", { noremap = true, silent = true })

      vim.api.nvim_set_keymap("n", "<leader>-", "<cmd>lua OpenSplitTermH()<CR>", { noremap = true, silent = true })

      vim.api.nvim_set_keymap("n", "<leader><A-|>", "<cmd>vsplit<CR>", { noremap = true, silent = true })

      vim.api.nvim_set_keymap("n", "<leader><A-->", "<cmd>split<CR>", { noremap = true, silent = true })

      vim.api.nvim_set_keymap("t", "<C-[>", "<C-\\><C-n>", { noremap = true, silent = true })

      vim.api.nvim_set_keymap("t", "<A-c>", "<C-\\><C-n><cmd>bdelete!<CR>", { noremap = true, silent = true })

      vim.api.nvim_set_keymap('t', '<C-h>', '<C-\\><C-n><C-w>h', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('t', '<C-j>', '<C-\\><C-n><C-w>j', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('t', '<C-k>', '<C-\\><C-n><C-w>k', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('t', '<C-l>', '<C-\\><C-n><C-w>l', { noremap = true, silent = true })

      vim.api.nvim_set_keymap('t', '<A-.>', '<C-\\><C-n><cmd>bnext<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('t', '<A-,>', '<C-\\><C-n><cmd>bprevious<CR>', { noremap = true, silent = true })


    '';

    # plugins.toggleterm.enable = true;
  };
}
