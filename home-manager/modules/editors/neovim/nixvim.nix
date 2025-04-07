{pkgs, ...}: {
  imports = [
    # Core

    ./plugins/lazy.nix
    ./plugins/terminal.nix
    # ./plugins/gitsigns.nix
    ./plugins/telescope.nix
    ./plugins/conform.nix
    ./plugins/lsp.nix
    ./plugins/nvim-cmp.nix
    # ./plugins/blink.nix
    ./plugins/mini.nix
    ./plugins/luasnip.nix
    ./plugins/treesitter.nix

    ./plugins/custom/plugins/img-clip.nix
    # ./plugins/custom/plugins/vim-ripgrep.nix
    # ./plugins/custom/plugins/markdown.nix
    ./plugins/custom/plugins/neotest.nix
    ./plugins/custom/plugins/neogen.nix
    ./plugins/kickstart/plugins/debug.nix
    ./plugins/custom/plugins/leetcode.nix
    ./plugins/custom/plugins/hydra.nix
    # ./plugins/nnnNvim.nix
    # ./plugins/surround.nixy

    ./plugins/custom/plugins/vimtex.nix

    ./plugins/kickstart/plugins/indent-blankline.nix
    # ./plugins/kickstart/plugins/lint.nix
    # ./plugins/kickstart/plugins/autopairs.nix

    # Plug

    ./plugins/custom/plugins/undotree.nix
    ./plugins/custom/plugins/neorg.nix
    ./plugins/custom/plugins/interim-ls.nix
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
    # ./plugins/custom/plugins/lazy.nix
    # ./plugins/custom/plugins/typr.nix
    ./plugins/custom/plugins/diagnostics.nix
    ./plugins/custom/plugins/leap.nix
    # ./plugins/custom/plugins/obsidian.nix
    # ./plugins/custom/plugins/lazygit.nix
    # ./plugins/custom/plugins/noice.nix
    # ./plugins/custom/plugins/firenvim.nix
    # ./plugins/custom/plugins/harpoon.nix
    # ./plugins/custom/plugins/telescope-zotero.nix

    #./plugins/custom/plugins/nougat.nix

    # jupyter
    ./plugins/custom/plugins/jupyter/molten.nix
    ./plugins/custom/plugins/jupyter/quarto.nix
    ./plugins/custom/plugins/jupyter/otter.nix
    ./plugins/custom/plugins/jupyter/jupytext.nix
    ./plugins/custom/plugins/TSObjects/treesitter-textobjects.nix
    ./plugins/custom/plugins/image.nix

    # frplugin
    ./plugins/ftpluginx.nix
    ./plugins/wrapperFloaterm/nnnTerm.nix
    # ./plugins/wrapperFloaterm/yaziTerm.nix
    # ./plugins/wrapperFloaterm/ripgrepTerm.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

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
      completeopt = [
        "menu" # Показывает меню автодополнения, но не выбирает первый элемент
        "menuone" # Показывает меню даже если есть только один вариант
        "noselect" # Не выбирает первый вариант автоматически
      ];

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
      foldenable = true;
      foldlevelstart = -1;
      fillchars = {
        horiz = "━";
        horizup = "┻";
        horizdown = "┳";
        vert = "┃";
        vertleft = "┫";
        vertright = "┣";
        verthoriz = "╋";

        eob = " ";
        diff = "\\";

        fold = " ";
        foldopen = "~";
        foldclose = "-";

        msgsep = "‾";
      };

      # synmaxcol = 100;
      # writebackup = false;
      # pumheight = 5;
      # title = true;
      # showmatch = true;
      # matchtime = 1;
      # report = 9001;

      # swapfile = false;

      # tabstop = 4;
      # shiftwidth = 4;
      #
      # expandtab = true;
      # autoindent = true;
      # };
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
        key = "<C-n>";
        action = "<CMD>Oil<CR>";
      }
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
        key = "?";
        action = "<nop>";
      }
      {
        mode = "n";
        key = "<leader>p";
        action = "<cmd>PasteImage<cr>";
      }

      {
        mode = "n";
        key = "<leader>fi";
        action.__raw = ''

          function()
            local telescope = require("telescope.builtin")
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")

            telescope.find_files({
              attach_mappings = function(_, map)
                local function embed_image(prompt_bufnr)
                  local entry = action_state.get_selected_entry()
                  local filepath = entry[1]
                  actions.close(prompt_bufnr)

                  local img_clip = require("img-clip")
                  img_clip.paste_image(nil, filepath)
                end

                map("i", "<CR>", embed_image)
                map("n", "<CR>", embed_image)

                return true
              end,
            })
          end

        '';
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
        group = "kickstart-highlight-yank";
        callback.__raw = ''
          function()
            vim.highlight.on_yank()
          end
        '';
      }
    ];

    extraPlugins = with pkgs.vimPlugins; [
    ];

    extraConfigLuaPre = ''
      vim.loader.enable()
    '';

    extraConfigLuaPost = ''
      -- vim: ts=2 sts=2 sw=2 et
    '';
  };
}
