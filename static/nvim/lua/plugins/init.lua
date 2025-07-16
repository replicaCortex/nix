return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- {
  --   "mfussenegger/nvim-lint",
  --   event = "BufWritePre", -- uncomment for format on save
  --   config = function()
  --     require "configs.linter"
  --   end,
  -- },

  -- test new blink
  { import = "nvchad.blink.lazyspec" },
  {
    "Saghen/blink.cmp",
    optional = true,
    opts = function(_, opts)
      if not opts.keymap then
        opts.keymap = {}
      end
      opts.keymap["<Tab>"] = { "snippet_forward", "fallback" }
      opts.keymap["<S-Tab>"] = { "snippet_backward", "fallback" }
      opts.cmdline = {
        keymap = {
          ["<Tab>"] = { "show", "accept" },
        },
        completion = { menu = { auto_show = true } },
      }
      opts.sources = {
        providers = {
          cmdline = {
            min_keyword_length = function(ctx)
              if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
                return 3
              end
              return 0
            end,
          },
        },
      }
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "lua",
        "html",
        "css",
        "latex",
        "python",
        "nix",
      },
    },
  },

  {
    "ggandor/leap.nvim",
    keys = {
      { "s", "<Plug>(leap-forward)", desc = "leap forward" },
      { "S", "<Plug>(leap-backward)", desc = "leap basckward" },
    },
    config = function()
      require "configs.leap"
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "debugloop/telescope-undo.nvim",
    },
    opts = function(_, conf)
      conf.defaults = {
        layout_strategy = "flex",
        layout_config = {
          flex = {
            flip_columns = 140,
          },
          vertical = {
            prompt_position = "top",
            mirror = true,
          },

          horizontal = {
            prompt_position = "top",
          },
        },
        sorting_strategy = "ascending",

        mappings = {
          i = {
            ["<c-c>"] = require("telescope.actions").delete_buffer + require("telescope.actions").move_to_top,
            ["<Esc>"] = require("telescope.actions").close,
            ["<C-u>"] = false,
          },
        },
        file_ignore_patterns = {
          "%.lock",
          "__pycache__/",
        },
      }

      return conf
    end,
  },

  {
    "HakonHarnes/img-clip.nvim",
    ft = { "markdown", "tex" },
    config = function()
      require "configs.img-clip"
    end,
    keys = {
      { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
    },
  },

  {
    "zk-org/zk-nvim",
    ft = "markdown",

    config = function()
      require "configs.zk"
    end,
  },

  {
    "lervag/vimtex",
    ft = "tex",

    config = function()
      require "configs.vimtex"
    end,
  },

  {
    "OXY2DEV/markview.nvim",
    ft = { "markdown" },
    opts = {
      preview = {
        filetypes = { "md", "markdown" },
      },
    },
    config = function()
      require "configs.markview"
    end,
  },

  {
    "Wansmer/langmapper.nvim",
    lazy = false,
    priority = 1, -- High priority is needed if you will use `autoremap()`

    config = function()
      require "configs.langmapper"
    end,
  },

  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      local translate_key = require("langmapper.utils").translate_keycode
      opts.filter = function(mapping)
        return mapping.lhs
          and mapping.lhs == translate_key(mapping.lhs, "default", "ru")
          and mapping.desc
          and mapping.desc:find "LM" == nil
      end
    end,
  },

  {
    "Wansmer/symbol-usage.nvim",

    event = "LspAttach",
    config = function()
      require "configs.symbol-usage"
    end,
  },

  -- {
  --   "SUSTech-data/neopyter",
  --   cmd = "Neopyter",
  --
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --     "AbaoFromCUG/websocket.nvim",
  --
  --     opts = {
  --       mode = "direct",
  --       remote_address = "127.0.0.1:9001",
  --       file_pattern = { "*.ju.*" },
  --     },
  --   },
  --   config = function()
  --     require "configs.jupyter"
  --   end,
  -- },

  {
    "rachartier/tiny-glimmer.nvim",
    event = "VeryLazy",
    priority = 10,

    config = function()
      require "configs.tiny-glimmmer"
    end,
  },

  -- disebale plug
  {
    "NvChad/nvterm",
    enabled = false,
  },

  {
    "nvzone/menu",
    enabled = false,
  },

  {
    "nvzone/minty",
    enabled = false,
  },

  {
    "mason-org/mason.nvim",
    enabled = false,
  },

  {
    "rafamadriz/friendly-snippets",
    enabled = false,
  },

  {
    "lewis6991/gitsigns.nvim",
    enabled = false,
  },

  {
    "nvim-tree/nvim-tree.lua",
    enabled = false,
  },
}
