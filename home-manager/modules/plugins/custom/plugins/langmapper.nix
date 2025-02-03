{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      langmapper-nvim
    ];
    extraConfigLuaPre = ''
              require("langmapper").automapping { global = true, buffer = true }

      local function escape(str)
          -- You need to escape these characters to work correctly
          local escape_chars = [[;,."|\]]
          return vim.fn.escape(str, escape_chars)
      end

      -- Recommended to use lua template string
      local en = [[`qwertyuiop[]asdfghjkl;'zxcvbnm]]
      local ru = [[ёйцукенгшщзхъфывапролджэячсмить]]
      local en_shift = [[~QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>]]
      local ru_shift = [[ËЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ]]

      vim.opt.langmap = vim.fn.join({
          -- | `to` should be first     | `from` should be second
          escape(ru_shift) .. ';' .. escape(en_shift),
          escape(ru) .. ';' .. escape(en),
      }, ',')


      require("leap.util")["get-input"] = function()
          local ok, ch = pcall(vim.fn.getcharstr)
          if ok and ch ~= vim.api.nvim_replace_termcodes("<esc>", true, false, true) then
              return require("langmapper.utils").translate_keycode(ch, "default", "ru")
          end
      end

      -- Map
      local map = require('langmapper').map

      vim.keymap.set({ 'n', 'x', 'o' }, 'ы', '<Plug>(leap-forward)')
      vim.keymap.set({ 'n', 'x', 'o' }, 'Ы', '<Plug>(leap-backward)')

      -- vim.keymap.set("n", "", "")

      map("n", "<leader>.", "gcc", { desc = "toggle comment", remap = true })
      map("v", "<leader>.", "gc", { desc = "toggle comment", remap = true })

      map("n", "<C-т>", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })
      map("n", "<leader>у", "<cmd>NvimTreeFocus<CR>", { desc = "nvimtree focus window" })

      map("n", "<leader>ац", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
      map("n", "<leader>ар", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" })
      map("n", "<leader>ащ", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" })
      map("n", "<leader>сь", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
      map("n", "<leader>пе", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })
      -- map("n", "<leader>зе", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" })
      map("n", "<leader>ат", "<cmd>NoiceTelescope<CR>", { desc = "telescope pick hidden term" })

      map("n", "<leader>аа", "<cmd>Telescope find_files<cr>", { desc = "telescope find files" })
      map(
          "n",
          "<leader>аф",
          "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
          { desc = "telescope find all files" }
      )

      map("t", "<C-ч>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })

      map({ "n", "t" }, "<A-м>", function()
          require("nvchad.term").toggle { pos = "vsp", id = "vtoggleTerm" }
      end, { desc = "terminal toggleable vertical term" })

      map({ "n", "t" }, "<A-р>", function()
          require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
      end, { desc = "terminal toggleable horizontal term" })

      map("i", "<C-и>", "<ESC>^i", { desc = "move beginning of line" })
      map("i", "<C-у>", "<End>", { desc = "move end of line" })
      map("i", "<C-р>", "<Left>", { desc = "move left" })
      map("i", "<C-д>", "<Right>", { desc = "move right" })
      map("i", "<C-о>", "<Down>", { desc = "move down" })
      map("i", "<C-л>", "<Up>", { desc = "move up" })

      map("n", "<C-ы>", "<cmd>w<CR>", { desc = "general save file" })

      -- vim.api.nvim_create_user_command('ц', vim.cmd('write'), {})

      map("n", "<C-с>", "<cmd>%y+<CR>", { desc = "general copy whole file" })


      -- vim.api.nvim_set_keymap('n', 'жР', '<Cmd>lua require("harpoon"):list():append()<CR>',
      --     { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', 'жр',
          '<Cmd>lua require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())<CR>', { noremap = true, silent = true })

      vim.keymap.set("n", "<leader>ещ", ":noautocmd TodoTelescope<CR> ")

      -- local ls = require("luasnip")
      --
      -- vim.keymap.set({ "i", "s" }, "<A-д>", function() ls.jump(1) end, { silent = true })
      -- vim.keymap.set({ "i", "s" }, "<A-о>", function() ls.jump(-1) end, { silent = true })

    '';
  };
}
