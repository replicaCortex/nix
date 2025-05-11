{...}: {
  imports = [
    # Core

    ./plugins/lazy.nix
    # ./plugins/terminal.nix
    # ./plugins/gitsigns.nix
    # ./plugins/telescope.nix
    ./plugins/conform.nix
    ./plugins/lsp.nix
    ./plugins/nvim-cmp.nix
    # ./plugins/blink.nix
    ./plugins/mini.nix
    ./plugins/luasnip.nix
    ./plugins/treesitter.nix

    ./plugins/custom/plugins/img-clip.nix
    # ./plugins/custom/plugins/make.nix
    ./plugins/custom/plugins/markdown.nix
    # ./plugins/custom/plugins/neotest.nix
    # ./plugins/custom/plugins/neogen.nix
    # ./plugins/kickstart/plugins/debug.nix
    # ./plugins/custom/plugins/leetcode.nix
    # ./plugins/custom/plugins/hydra.nix
    # ./plugins/custom/plugins/hmts.nix
    # ./plugins/nnnNvim.nix
    # ./plugins/surround.nix

    ./plugins/custom/plugins/vimtex.nix

    ./plugins/kickstart/plugins/indent-blankline.nix
    # ./plugins/kickstart/plugins/lint.nix
    # ./plugins/kickstart/plugins/autopairs.nix

    # Plug

    ./plugins/custom/plugins/undotree.nix
    ./plugins/custom/plugins/neorg.nix
    ./plugins/custom/plugins/interim-ls.nix
    # ./plugins/custom/plugins/org.nix
    ./plugins/custom/plugins/fzf.lua.nix
    # ./plugins/custom/plugins/norg-fmt.nix
    # ./plugins/custom/plugins/todo.nix
    # ./plugins/custom/plugins/vim-startuptime.nix

    # ./plugins/custom/plugins/multicursors.nix
    # ./plugins/custom/plugins/lualine.nix
    # ./plugins/custom/plugins/oil.nix
    # ./plugins/custom/plugins/pencil.nix
    # ./plugins/custom/plugins/cmp-zotcite.nix
    # ./plugins/custom/plugins/zotcite.nix
    # ./plugins/custom/plugins/zen-mode.nix
    ./plugins/custom/plugins/langmapper.nix
    ./plugins/custom/plugins/colorizer.nix
    # ./plugins/custom/plugins/volt.nix
    # ./plugins/custom/plugins/typr.nix
    ./plugins/custom/plugins/diagnostics.nix
    ./plugins/custom/plugins/leap.nix
    # ./plugins/custom/plugins/flash.nix
    # ./plugins/custom/plugins/obsidian.nix
    # ./plugins/custom/plugins/lazygit.nix
    # ./plugins/custom/plugins/noice.nix
    # ./plugins/custom/plugins/firenvim.nix
    # ./plugins/custom/plugins/harpoon.nix
    # ./plugins/custom/plugins/telescope-zotero.nix

    #./plugins/custom/plugins/nougat.nix

    # jupyter
    # ./plugins/custom/plugins/jupyter/molten.nix
    # ./plugins/custom/plugins/jupyter/quarto.nix
    # ./plugins/custom/plugins/jupyter/otter.nix
    # ./plugins/custom/plugins/jupyter/jupytext.nix
    # ./plugins/custom/plugins/TSObjects/treesitter-textobjects.nix
    ./plugins/custom/plugins/image.nix

    # frplugin
    # ./plugins/ftpluginx.nix
    # ./plugins/custom/plugins/fzflua.nix
    # ./plugins/wrapperFloaterm/fzf.nix
    # ./plugins/wrapperFloaterm/nnnTerm.nix
    # ./plugins/wrapperFloaterm/yaziTerm.nix
    # ./plugins/wrapperFloaterm/ripgrepTerm.nix
    # ./plugins/custom/plugins/vim-ripgrep.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    performance.byteCompileLua = {
      enable = true;
      plugins = true;
    };
    # performance.combinePlugins = {
    #   enable = true;
    # };

    withRuby = false;
    withPerl = false;
    withNodeJs = false;

    colorschemes = {
      catppuccin = {
        settings = {
          # flavour = "latte";
          no_italic = true;
        };
        enable = true;
        # settings = {
        #   integrations = {
        #     cmp = true;
        #     mini = true;
        #     treesitter = true;
        #   };
        # };
      };
    };

    globals = {
      mapleader = " ";
      maplocalleader = ";";

      loaded_ruby_provider = 0;
      loaded_perl_provider = 0;
    };

    clipboard.providers.xclip.enable = true;

    opts = {
      number = true;
      relativenumber = true;

      swapfile = false;

      splitbelow = true;
      splitright = true;
      timeoutlen = 400;
      undofile = true;

      laststatus = 3;

      mouse = "a";

      showmode = false;

      clipboard = "unnamedplus";

      breakindent = true;

      ignorecase = true;
      smartcase = true;

      signcolumn = "yes";
      updatetime = 250;
      list = true;
      inccommand = "split";
      cursorline = true;
      cursorlineopt = "number";
      scrolloff = 10;
      hlsearch = true;

      foldlevel = 99; # Folds with a level higher than this number will be closed
      # foldcolumn = "1";
      foldenable = false;
      foldlevelstart = -1;
      # foldmethod = "expr";
      # foldexpr = "vimtex#fold#level(v:lnum)";
      fillchars = {
        horiz = "━";
        horizup = "┻";
        horizdown = "┳";
        vert = "┃";
        vertleft = "┫";
        vertright = "┣";
        verthoriz = "╋";

        eob = " ";
        diff = " ";

        fold = " ";
        foldopen = "~";
        foldclose = "-";

        msgsep = "‾";
      };

      synmaxcol = 100;
      pumheight = 5;
      title = true;

      # tabstop = 4;
      # shiftwidth = 4;
      #
      # expandtab = true;
      # autoindent = true;
      # };
    };

    keymaps = [
      # {
      #   mode = "c";
      #   key = "<A-k>";
      #   action = "<C-p>";
      #   options = {
      #     noremap = true;
      #     silent = true;
      #   };
      # }
      # {
      #   mode = "c";
      #   key = "<A-l>";
      #   action = "<C-n>";
      #   options = {
      #     noremap = true;
      #     silent = true;
      #   };
      # }
      {
        mode = "i";
        key = "<C-k>";
        action = "<Up>";
      }
      {
        mode = "i";
        key = "<C-j>";
        action = "<Down>";
      }
      {
        mode = "i";
        key = "<C-l>";
        action = "<Right>";
      }
      {
        mode = "i";
        key = "<C-h>";
        action = "<Left>";
      }
      {
        mode = "v";
        key = "<leader>/";
        action = "gc";
        options = {
          remap = true;
        };
      }
      {
        mode = "n";
        key = "<leader>/";
        action = "gcc";
        options = {
          remap = true;
        };
      }
      {
        mode = "v";
        key = "p";
        action = "P";
        options = {
          silent = true;
        };
      }
      {
        mode = "n";
        key = "U";
        action = "<C-r>";
        options = {
          silent = true;
        };
      }
      {
        mode = "n";
        key = "q:";
        action = "<nop>";
        options = {
          noremap = true;
          silent = true;
        };
      }
      {
        mode = "v";
        key = "K";
        action = "<nop>";
        options = {
          noremap = true;
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<Esc>";
        action = "<cmd>nohlsearch<CR>";
      }

      {
        mode = "n";
        key = "q";
        action = "<cmd>nohlsearch<CR>";
      }

      {
        mode = "n";
        key = "Q";
        action = "<nop>";
      }

      {
        mode = "n";
        key = "й";
        action = "<nop>";
      }
      {
        mode = "n";
        key = "Й";
        action = "<nop>";
      }

      {
        mode = "n";
        key = "q";
        action = "<nop>";
      }
      {
        mode = "n";
        key = "n";
        action = "<nop>";
      }

      {
        mode = "n";
        key = "N";
        action = "<nop>";
      }
      {
        mode = "n";
        key = "<C-h>";
        action = "<C-w><C-h>";
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<C-w><C-l>";
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<C-w><C-j>";
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w><C-k>";
      }
      # {
      #   mode = "n";
      #   key = "?";
      #   action = "<nop>";
      # }
      {
        mode = "n";
        key = "<leader>p";
        action = "<cmd>PasteImage<cr>";
      }

      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w><C-k>";
      }

      {
        mode = "n";
        key = "<localleader>q";
        action = ":bd<CR>";
      }
    ];

    autoGroups = {
      kickstart-highlight-yank = {
        clear = true;
      };
    };

    autoCmd = [
      {
        event = ["TextYankPost"];
        group = "kickstart-highlight-yank";
        callback.__raw = ''
          function()
            vim.highlight.on_yank()
          end
        '';
      }
    ];

    # extraPlugins = with pkgs.vimPlugins; [
    # ];

    extraConfigLuaPre = ''
      vim.opt.wrap = true
      vim.opt.linebreak = true
      vim.opt.breakindent = true
      vim.opt.breakindentopt = 'list:-1'
      vim.opt.formatlistpat = '^\\s*[-~>]\\+\\s\\((.)\\s\\)\\?'

      vim.loader.enable()

      vim.api.nvim_create_user_command('DF', function()
        vim.fn.delete(vim.fn.expand('%:p'))
        vim.cmd('bd')
      end, {})

      function RenameCurrentFile()
        local old = vim.fn.expand("%")
        vim.ui.input({ prompt = "New name: ", default = old }, function(new)
          if not new or new == "" or new == old then
            return
          end
          vim.cmd("saveas " .. new)
          vim.cmd("silent !rm " .. old)
          vim.cmd("e " .. new)
        end)
      end

      vim.api.nvim_create_user_command("RF", function()
        RenameCurrentFile()
      end, {})
    '';

    extraConfigLuaPost = ''
      -- vim: ts=2 sts=2 sw=2 et
    '';
  };
}
