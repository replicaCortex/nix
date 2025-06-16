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

  -- test new blink
  { import = "nvchad.blink.lazyspec" },
  {
    "Saghen/blink.cmp",
    optional = true,
    opts = function(_, opts)
      if not opts.keymap then
        opts.keymap = {}
      end
      opts.keymap["<Tab>"] = { "snippet_forward" }
      opts.keymap["<S-Tab>"] = { "snippet_backward" }
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
        "norg",
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
    "ibhagwan/fzf-lua",
    event = "VeryLazy",

    config = function()
      require "configs.fzf"
    end,
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
    lazy = "VeryLazy",
    ft = "tex",

    config = function()
      require "configs.vimtex"
    end,
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },

    config = function()
      require "configs.markdown-render"
    end,
  },

  {
    "Wansmer/langmapper.nvim",
    ft = { "markdown", "tex" },

    config = function()
      require "configs.langmapper"
    end,
  },

  -- disebale plug
  {
    "NvChad/nvterm",
    enabled = false,
  },

  {
    "mason-org/mason.nvim",
    enabled = false,
  },

  {
    "nvim-telescope/telescope.nvim",
    enabled = false,
  },

  {
    "rafamadriz/friendly-snippets",
    enabled = false,
  },

  {
    "replicaCortex/friendly-snippets",
    enabled = false,
  },
}
