{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Plugins
    ./plugins/gitsigns.nix
    ./plugins/telescope.nix
    ./plugins/conform.nix
    ./plugins/lsp.nix
    ./plugins/nvim-cmp.nix
    # ./plugins/blink.nix
    ./plugins/mini.nix
    ./plugins/treesitter.nix

    ./plugins/kickstart/plugins/debug.nix
    ./plugins/kickstart/plugins/indent-blankline.nix
    #./plugins/kickstart/plugins/lint.nix
    ./plugins/kickstart/plugins/autopairs.nix

    ./plugins/custom/plugins/image.nix
    # ./plugins/custom/plugins/multicursors.nix
    # ./plugins/custom/plugins/fidget.nix
    ./plugins/custom/plugins/leetcode.nix
    # ./plugins/custom/plugins/norg-fmt.nix
    # ./plugins/custom/plugins/lualine.nix
    ./plugins/custom/plugins/oil.nix
    ./plugins/custom/plugins/undotree.nix
    # ./plugins/custom/plugins/neorg.nix
    ./plugins/custom/plugins/todo.nix
    ./plugins/custom/plugins/colorizer.nix
    # ./plugins/custom/plugins/volt.nix
    # ./plugins/custom/plugins/typr.nix
    ./plugins/custom/plugins/diagnostics.nix
    ./plugins/custom/plugins/leap.nix
    ./plugins/custom/plugins/vimtex.nix
    # ./plugins/custom/plugins/lazygit.nix
    # ./plugins/custom/plugins/noice.nix
    # ./plugins/custom/plugins/firenvim.nix
    ./plugins/custom/plugins/harpoon.nix
    ./plugins/custom/plugins/markdown.nix

    #./plugins/custom/plugins/nougat.nix

    # jupyter
    ./plugins/custom/plugins/jupyter/molten.nix
    ./plugins/custom/plugins/jupyter/quarto.nix
    ./plugins/custom/plugins/jupyter/otter.nix
    ./plugins/custom/plugins/jupyter/jupytext.nix

    # frplugin
    ./plugins/ftpluginx.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    colorschemes = {
      catppuccin = {
        enable = true;
        # settings = {
        #   style = "moon";
        # };
      };
    };

    globals = {
      mapleader = " ";
      maplocalleader = ";";
    };

    clipboard.providers.xclip.enable = true;

    opts = {
      number = true;
      relativenumber = true;

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

      #listchars.__raw = "{ tab = '» ', trail = '·', nbsp = '␣' }";

      inccommand = "split";

      cursorline = true;
      cursorlineopt = "number";

      scrolloff = 10;

      hlsearch = true;
    };

    keymaps = [
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
        key = "Q";
        action = "<nop>";
      }

      {
        mode = "n";
        key = "q";
        action = "<nop>";
      }

      # {
      #   mode = "n";
      #   key = "<Esc>";
      #   action = "<C-c>";
      # }
      {
        mode = "t";
        key = "<Esc><Esc>";
        action = "<C-\\><C-n>";
        options = {
          desc = "Exit terminal mode";
        };
      }
      {
        mode = "n";
        key = "<C-n>";
        action = "<CMD>Oil<CR>";
      }
      # {
      #   mode = "n";
      #   key = "<C-n>";
      #   action = "<C-p>";
      # }
      # TIP: Disable arrow keys in normal mode
      /*
      {
        mode = "n";
        key = "<left>";
        action = "<cmd>echo 'Use h to move!!'<CR>";
      }
      {
        mode = "n";
        key = "<right>";
        action = "<cmd>echo 'Use l to move!!'<CR>";
      }
      {
        mode = "n";
        key = "<up>";
        action = "<cmd>echo 'Use k to move!!'<CR>";
      }
      {
        mode = "n";
        key = "<down>";
        action = "<cmd>echo 'Use j to move!!'<CR>";
      }
      */
      {
        mode = "n";
        key = "<C-h>";
        action = "<C-w><C-h>";
        options = {
          desc = "Move focus to the left window";
        };
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<C-w><C-l>";
        options = {
          desc = "Move focus to the right window";
        };
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<C-w><C-j>";
        options = {
          desc = "Move focus to the lower window";
        };
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w><C-k>";
        options = {
          desc = "Move focus to the upper window";
        };
      }

      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w><C-k>";
        options = {
          desc = "Move focus to the upper window";
        };
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
        desc = "Highlight when yanking (copying) text";
        group = "kickstart-highlight-yank";
        callback.__raw = ''
          function()
            vim.highlight.on_yank()
          end
        '';
      }
    ];

    plugins = {
      web-devicons.enable = true;
    };

    extraPlugins = with pkgs.vimPlugins; [
      nvim-web-devicons
      # multiple-cursors
    ];

    extraConfigLuaPre = ''
      if vim.g.have_nerd_font then
        require('nvim-web-devicons').setup {}
      end



    '';

    extraConfigLuaPost = ''
      -- vim: ts=2 sts=2 sw=2 et
    '';
  };
}
