{
  programs.nixvim = {
    # plugins.toggleterm = {
    #   enable = true;
    #
    #   lazyLoad = {
    #     settings = {
    #       cmd = "ToggleTerm";
    #       keys = [
    #         "<localleader>lz"
    #         "<localleader>at"
    #         "<A-n>"
    #       ];
    #     };
    #   };
    #
    #   settings = {
    #     direction = "float";
    #     float_opts.__raw = ''
    #       -- function()
    #       --    local ui = vim.api.nvim_list_uis()[1]
    #       --    return {
    #       --      border = "curved",
    #       --      width = math.floor(ui.width * 0.8),
    #       --      height = math.floor(ui.height * 0.8),
    #       --    }
    #       --  end
    #     '';
    #   };
    # };

    # keymaps = [
    #   {
    #     mode = "n";
    #     key = "<A-n>";
    #     action = "<cmd>ToggleTerm<CR>";
    #     options = {
    #       desc = "Open Terminal";
    #     };
    #   }
    #   {
    #     mode = "n";
    #     key = "<localleader>lz";
    #     action.__raw = ''
    #       function()
    #         local toggleterm = require('toggleterm.terminal')
    #
    #         toggleterm.Terminal:new({cmd = 'git',hidden = true}):toggle()
    #       end
    #     '';
    #     options = {
    #       silent = true;
    #     };
    #   }
    #   {
    #     mode = "n";
    #     key = "<localleader>at";
    #     action.__raw = ''
    #       function()
    #         local toggleterm = require('toggleterm.terminal')
    #
    #         toggleterm.Terminal:new({cmd = 'atac',hidden = true}):toggle()
    #       end
    #     '';
    #     options = {
    #       silent = true;
    #     };
    #   }
    # ];

    # extraConfigLuaPre = ''
    #   -- vim.api.nvim_create_autocmd("TermOpen", {
    #   --     pattern = "*",
    #   --     command = "setlocal nonumber norelativenumber"
    #   -- })
    #   --
    #   -- vim.api.nvim_create_autocmd("BufEnter", {
    #   --     pattern = "term://*",
    #   --     callback = function()
    #   --       vim.cmd("startinsert")
    #   --     end,
    #   -- })
    #   --
    #   --
    #   --
    #   -- -- function OpenSplitTermV()
    #   -- --     local width = math.floor(vim.o.columns * 0.2)
    #   -- --     vim.cmd("vsplit term://zsh")
    #   -- --     vim.cmd("vertical resize " .. width)
    #   -- --     vim.cmd("startinsert")
    #   -- -- end
    #   --
    #   --
    #   -- function OpenSplitTermV()
    #   --     local buf = vim.api.nvim_create_buf(false, true)
    #   --     vim.cmd("vsplit")
    #   --     vim.api.nvim_win_set_buf(0, buf)
    #   --     vim.fn.termopen("zsh")
    #   --     vim.cmd("vertical resize " .. math.floor(vim.o.columns * 0.2))
    #   --     vim.cmd("startinsert")
    #   -- end
    #   --
    #   -- function OpenSplitTermH()
    #   --     local buf = vim.api.nvim_create_buf(false, true)
    #   --     vim.cmd("split")
    #   --     vim.api.nvim_win_set_buf(0, buf)
    #   --     vim.fn.termopen("zsh")
    #   --     vim.cmd("resize 10")
    #   --     vim.cmd("startinsert")
    #   -- end
    #   --
    #   -- function OpenNewBufTerm()
    #   --     local buf = vim.api.nvim_create_buf(true, false)
    #   --     vim.api.nvim_set_current_buf(buf)
    #   --     vim.fn.termopet("zsh")
    #   --     vim.cmd("startinsert")
    #   -- end
    #   --
    #   -- vim.api.nvim_set_keymap("n", "<leader>nt", "<cmd>lua OpenNewBufTerm()<CR>", { noremap = true, silent = true })
    #   --
    #   -- vim.api.nvim_set_keymap("n", "<leader>|", "<cmd>lua OpenSplitTermV()<CR>", { noremap = true, silent = true })
    #   --
    #   -- vim.api.nvim_set_keymap("n", "<leader>-", "<cmd>lua OpenSplitTermH()<CR>", { noremap = true, silent = true })
    #   --
    #   vim.api.nvim_set_keymap("n", "<leader>|", "<cmd>vsplit<CR>", { noremap = true, silent = true })
    #
    #   vim.api.nvim_set_keymap("n", "<leader>-", "<cmd>split<CR>", { noremap = true, silent = true })
    #   --
    #   vim.api.nvim_set_keymap("t", "<leader>[", "<C-\\><C-n>", { noremap = true, silent = true })
    #   --
    #   -- vim.api.nvim_set_keymap("t", "<A-c>", "<C-\\><C-n><cmd>bdelete!<CR>", { noremap = true, silent = true })
    #   --
    #   -- vim.api.nvim_set_keymap('t', '<C-h>', '<C-\\><C-n><C-w>h', { noremap = true, silent = true })
    #   -- vim.api.nvim_set_keymap('t', '<C-j>', '<C-\\><C-n><C-w>j', { noremap = true, silent = true })
    #   -- vim.api.nvim_set_keymap('t', '<C-k>', '<C-\\><C-n><C-w>k', { noremap = true, silent = true })
    #   -- vim.api.nvim_set_keymap('t', '<C-l>', '<C-\\><C-n><C-w>l', { noremap = true, silent = true })
    #   --
    #
    #   vim.api.nvim_set_keymap('t', '<Esc>', '<Esc>', {noremap = true})
    #   vim.api.nvim_del_keymap('t', '<Esc>')
    #   -- Режим Normal: переключение терминала
    #   vim.api.nvim_set_keymap('n', '<A-n>', '<cmd>ToggleTerm<CR>', { noremap = true, silent = true })
    #
    #   -- Режим Terminal: для выхода из режима вставки терминала
    #   vim.api.nvim_set_keymap('t', '<A-n>', '<C-\\><C-n><cmd>ToggleTerm<CR>', { noremap = true, silent = true })
    #
    #   -- vim.api.nvim_set_keymap("n", "<leader><leader>", ":lua ManageTerminal()<CR>", { noremap = true, silent = true })
    #   -- vim.api.nvim_set_keymap("t", "<leader><leader>", "<C-\\><C-n>:lua ManageTerminal()<CR>", { noremap = true, silent = true })
    #
    # '';

    # NOTE: FLOATERM

    extraConfigLuaPre = ''
      -- vim.api.nvim_create_autocmd("TermOpen", {
      --     pattern = "*",
      --     command = "setlocal nonumber norelativenumber"
      -- })
      --
      -- vim.api.nvim_create_autocmd("BufEnter", {
      --     pattern = "term://*",
      --     callback = function()
      --       vim.cmd("startinsert")
      --     end,
      -- })
      --
      --
      --
      -- -- function OpenSplitTermV()
      -- --     local width = math.floor(vim.o.columns * 0.2)
      -- --     vim.cmd("vsplit term://zsh")
      -- --     vim.cmd("vertical resize " .. width)
      -- --     vim.cmd("startinsert")
      -- -- end
      --
      --
      -- function OpenSplitTermV()
      --     local buf = vim.api.nvim_create_buf(false, true)
      --     vim.cmd("vsplit")
      --     vim.api.nvim_win_set_buf(0, buf)
      --     vim.fn.termopen("zsh")
      --     vim.cmd("vertical resize " .. math.floor(vim.o.columns * 0.2))
      --     vim.cmd("startinsert")
      -- end
      --
      -- function OpenSplitTermH()
      --     local buf = vim.api.nvim_create_buf(false, true)
      --     vim.cmd("split")
      --     vim.api.nvim_win_set_buf(0, buf)
      --     vim.fn.termopen("zsh")
      --     vim.cmd("resize 10")
      --     vim.cmd("startinsert")
      -- end
      --
      -- function OpenNewBufTerm()
      --     local buf = vim.api.nvim_create_buf(true, false)
      --     vim.api.nvim_set_current_buf(buf)
      --     vim.fn.termopet("zsh")
      --     vim.cmd("startinsert")
      -- end
      --
      -- vim.api.nvim_set_keymap("n", "<leader>nt", "<cmd>lua OpenNewBufTerm()<CR>", { noremap = true, silent = true })
      --
      -- vim.api.nvim_set_keymap("n", "<leader>|", "<cmd>lua OpenSplitTermV()<CR>", { noremap = true, silent = true })
      --
      -- vim.api.nvim_set_keymap("n", "<leader>-", "<cmd>lua OpenSplitTermH()<CR>", { noremap = true, silent = true })
      --
      vim.api.nvim_set_keymap("n", "<leader>|", "<cmd>vsplit<CR>", { noremap = true, silent = true })

      vim.api.nvim_set_keymap("n", "<leader>-", "<cmd>split<CR>", { noremap = true, silent = true })
      --
      vim.api.nvim_set_keymap("t", "<leader>[", "<C-\\><C-n>", { noremap = true, silent = true })
      --
      -- vim.api.nvim_set_keymap("t", "<A-c>", "<C-\\><C-n><cmd>bdelete!<CR>", { noremap = true, silent = true })
      --
      -- vim.api.nvim_set_keymap('t', '<C-h>', '<C-\\><C-n><C-w>h', { noremap = true, silent = true })
      -- vim.api.nvim_set_keymap('t', '<C-j>', '<C-\\><C-n><C-w>j', { noremap = true, silent = true })
      -- vim.api.nvim_set_keymap('t', '<C-k>', '<C-\\><C-n><C-w>k', { noremap = true, silent = true })
      -- vim.api.nvim_set_keymap('t', '<C-l>', '<C-\\><C-n><C-w>l', { noremap = true, silent = true })
      --

      vim.api.nvim_set_keymap('t', '<A-.>', '<C-\\><C-n><cmd>FloatermNext<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('t', '<A-,>', '<C-\\><C-n><cmd>FloatermPrev<CR>', { noremap = true, silent = true })

      vim.api.nvim_set_keymap('t', '<A-c>', '<cmd>FloatermKill<CR><cmd>FloatermNext<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('t', '<A-N>', '<cmd>FloatermNew<CR>', { noremap = true, silent = true })

      vim.api.nvim_set_keymap('t', '<Esc>', '<Esc>', {noremap = true})
      vim.api.nvim_del_keymap('t', '<Esc>')

      -- vim.api.nvim_set_keymap('n', '<localleader>lz', '<cmd>FloatermNew git<CR>', { noremap = true, silent = true })
      -- vim.api.nvim_set_keymap('n', '<localleader>at', '<cmd>FloatermNew atac<CR>', { noremap = true, silent = true })

      -- vim.api.nvim_set_keymap("n", "<leader><leader>", ":lua ManageTerminal()<CR>", { noremap = true, silent = true })
      -- vim.api.nvim_set_keymap("t", "<leader><leader>", "<C-\\><C-n>:lua ManageTerminal()<CR>", { noremap = true, silent = true })

    '';

    plugins.floaterm = {
      enable = true;
      settings = {
        height = 0.8;
        # keymap_kill = "<Leader>fk";
        # keymap_new = "<Leader>ft";
        # keymap_next = "<Leader>fn";
        # keymap_prev = "<Leader>fp";
        keymap_toggle = "<A-n>";
        shell = "zsh";
        opener = "edit ";
        rootmarkers = [
          "build/CMakeFiles"
          ".project"
          ".git"
          ".hg"
          ".svn"
          ".root"
        ];
        title = "floaTerm";
        width = 0.8;
      };
    };
  };
}
