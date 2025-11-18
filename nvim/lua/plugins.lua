return {
  {
    "nvim-treesitter/nvim-treesitter",
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    config = function()
      require "configs.treesitter"
    end,
  },

  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    config = function()
      require "configs.conform"
    end,
  },

  {
    "neovim/nvim-lspconfig",

    dependencies = { "nvim-treesitter/nvim-treesitter", "m4xshen/hardtime.nvim", "lewis6991/gitsigns.nvim" },
    ft = { "python", "markdown", "rust", "tex", "lua", "typst", "nix", "sh", "fish", "just", "nu" },
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = function()
      return require "configs.snacks-keys"
    end,

    opts = function()
      return require "configs.snacks"
    end,
  },

  {
    "saghen/blink.cmp",
    version = "1.*",
    event = { "InsertEnter", "CmdLineEnter" },

    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        opts = { history = true, updateevents = "TextChanged" },
        config = function(_, opts)
          require("luasnip").config.set_config(opts)
          require "configs.snip"
        end,
      },
    },

    opts_extend = { "sources.default" },

    opts = function()
      return require "configs.blink"
    end,
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },

  {
    "lewis6991/gitsigns.nvim",
    lazy = true,
    config = function()
      require("gitsigns").setup {
        signcolumn = false,
        numhl = true,
      }
    end,
  },

  {
    "Wansmer/langmapper.nvim",
    lazy = false,
    priority = 1,

    config = function()
      require "configs.langmapper"
    end,
  },
  --- ui ---
  {
    "nvchad/ui",
    dependencies = { "nvim-tree/nvim-web-devicons", "nvchad/base46" },
    config = function()
      require "nvchad"
      vim.api.nvim_set_hl(0, "@comment", { fg = "#4E4E4E", italic = true })
      vim.api.nvim_set_hl(0, "Comment", { fg = "#656565", italic = true })
      vim.api.nvim_set_hl(0, "LspInlayHint", { bg = "#282828", fg = "#656565" })
      vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = "#83A598", bold = true })
    end,
  },

  {
    "nvchad/base46",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = true,
    build = function()
      require("base46").load_all_highlights()
    end,
  },

  {
    "rachartier/tiny-glimmer.nvim",
    keys = {
      "yy",
      "u",
      "r",
      "U",
      "R",

      { "y", mode = { "n", "x" } },
      { "p", mode = { "n", "x" } },
      { "P", mode = { "n", "x" } },
    },
    config = function()
      require "configs.tiny-glimmer"
    end,
  },

  --- other ---

  {
    "zk-org/zk-nvim",
    ft = { "markdown" },
    config = function()
      require "configs.zk"
    end,
  },

  {
    "m4xshen/hardtime.nvim",
    lazy = true,
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
      require("hardtime").setup()
    end,
  },

  {
    "saxon1964/neovim-tips",
    version = "*",
    lazy = true,
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    opts = {
      daily_tip = 0, -- 0 = off, 1 = once per day, 2 = every startup
    },
    keys = {
      { "<leader>nto", ":NeovimTips<CR>", desc = "Neovim tips" },
      { "<leader>ntr", ":NeovimTipsRandom<CR>", desc = "Show random tip" },
      { "<leader>nte", ":NeovimTipsEdit<CR>", desc = "Edit your tips" },
      { "<leader>nta", ":NeovimTipsAdd<CR>", desc = "Add your tip" },
      { "<leader>ntp", ":NeovimTipsPdf<CR>", desc = "Open tips PDF" },
    },
  },
}
