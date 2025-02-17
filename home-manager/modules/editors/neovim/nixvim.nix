{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Core

    # ./plugins/lazy.nix
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
    ./plugins/custom/plugins/markdown.nix
    ./plugins/custom/plugins/neotest.nix
    ./plugins/custom/plugins/neogen.nix
    ./plugins/kickstart/plugins/debug.nix
    # ./plugins/custom/plugins/leetcode.nix
    ./plugins/custom/plugins/hydra.nix

    ./plugins/custom/plugins/vimtex.nix

    ./plugins/kickstart/plugins/indent-blankline.nix
    # ./plugins/kickstart/plugins/lint.nix
    # ./plugins/kickstart/plugins/autopairs.nix

    # Plug

    ./plugins/custom/plugins/undotree.nix
    ./plugins/custom/plugins/neorg.nix
    ./plugins/custom/plugins/interim-ls.nix
    # ./plugins/custom/plugins/norg-fmt.nix
    ./plugins/custom/plugins/todo.nix
    # ./plugins/custom/plugins/vim-startuptime.nix

    # ./plugins/custom/plugins/multicursors.nix
    # ./plugins/custom/plugins/lualine.nix
    ./plugins/custom/plugins/oil.nix
    # ./plugins/custom/plugins/pencil.nix
    # ./plugins/custom/plugins/cmp-zotcite.nix
    # ./plugins/custom/plugins/zotcite.nix
    # ./plugins/custom/plugins/zen-mode.nix
    ./plugins/custom/plugins/langmapper.nix
    ./plugins/custom/plugins/colorizer.nix
    # ./plugins/custom/plugins/volt.nix
    # ./plugins/custom/plugins/lazy.nix
    # ./plugins/custom/plugins/typr.nix
    # ./plugins/custom/plugins/diagnostics.nix
    ./plugins/custom/plugins/leap.nix
    # ./plugins/custom/plugins/obsidian.nix
    # ./plugins/custom/plugins/lazygit.nix
    # ./plugins/custom/plugins/noice.nix
    # ./plugins/custom/plugins/firenvim.nix
    ./plugins/custom/plugins/harpoon.nix
    # ./plugins/custom/plugins/telescope-zotero.nix

    #./plugins/custom/plugins/nougat.nix

    # jupyter
    ./plugins/custom/plugins/jupyter/molten.nix
    ./plugins/custom/plugins/jupyter/quarto.nix
    ./plugins/custom/plugins/jupyter/otter.nix
    ./plugins/custom/plugins/jupyter/jupytext.nix
    ./plugins/custom/plugins/TSObjects/treesitter-textobjects.nix
    # ./plugins/custom/plugins/image.nix

    # frplugin
    ./plugins/ftpluginx.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

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

      # {
      #   mode = "n";
      #   key = "<leader>oi";
      #   action.__raw = ''
      #
      #     function()
      #         local oil = require(" oil ")
      #         local filename = oil.get_cursor_entry().name
      #         local dir = oil.get_current_dir()
      #         oil.close()oil
      #
      #         local img_clip = require(" img-clip ")
      #         img_clip.paste_image({}, dir .. filename)
      #       end
      #
      #   '';
      # }

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

      # {
      #   event = ["FileType"];
      #   pattern = ["markdown" "norg"];
      #   callback.__raw = ''
      #     function()
      #     require("image").setup = image_setup_original
      #     require("image").setup(_M.image_config)
      #     end
      #   '';
      # }
      # {
      #   event = ["BufWritePost"];
      #   pattern = "*.norg";
      #   callback.__raw = ''
      #     function()
      #       vim.highlight.on_yank()
      #     end
      #   '';
      # }
    ];

    plugins = {
      # web-devicons.enable = true;
    };

    # TODO: сделать ленивую загрузку
    extraPlugins = with pkgs.vimPlugins; [
      # nvim-web-devicons
    ];

    extraConfigLuaPre = ''
      if vim.g.have_nerd_font then
        require('nvim-web-devicons').setup {}
      end

      -- vim.api.nvim_create_autocmd({"FileType"}, {
      --     pattern = {"tex"},
      --     callback = function()
      --         -- Вызов функции pencil#init() (предполагая, что она доступна в Lua)
      --         -- Например:
      --         vim.cmd('call pencil#init()')
      --         vim.cmd(':set conceallevel=0 <CR>')
      --     end,
      -- })
    '';

    extraConfigLuaPost = ''
      -- vim: ts=2 sts=2 sw=2 et
    '';
  };
}
