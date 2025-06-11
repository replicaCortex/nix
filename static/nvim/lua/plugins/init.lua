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
    "ibhagwan/fzf-lua",
    event = "VeryLazy",

    config = function()
      require "configs.fzf"
    end,
  },

  {
    "lervag/vimtex",
    ft = "tex",
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
}
