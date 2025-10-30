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

    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "python", "markdown", "rust", "tex", "lua", "typst", "nix" },
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- lazy.nvim
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = {
      {
        "<leader>ff",
        function()
          require("snacks.picker").smart()
        end,
      },
      {
        "<leader>fg",
        function()
          require("snacks.picker").grep()
        end,
      },
      {
        "<leader>fd",
        function()
          require("snacks.picker").diagnostics_buffer()
        end,
      },
      {
        "<leader>fu",
        function()
          require("snacks.picker").undo()
        end,
      },
      {
        "<C-n>",
        function()
          require("snacks.picker").explorer()
        end,
      },
      {
        "<leader>fo",
        function()
          require("snacks.picker").recent()
        end,
      },
      {
        "<leader>h",
        function()
          require("snacks.picker").help()
        end,
      },
      {
        "grr",
        function()
          require("snacks.picker").lsp_references()
        end,
      },
      {
        "<leader>fb",
        function()
          require("snacks.picker").buffers()
        end,
      },
      {
        "<leader>fs",
        function()
          require("snacks.picker").lsp_symbols()
        end,
      },
      {
        "<leader>fn",
        function()
          require("snacks.picker").notifications()
        end,
      },
      {
        "<leader>fh",
        function()
          require("snacks.picker").command_history()
        end,
      },
    },
    opts = {
      picker = {
        layout = {
          preset = "dropdown",
        },
        win = {
          input = {
            keys = {
              ["<C-u>"] = { "<Esc>ddi", mode = { "i" }, expr = true },
            },
          },
        },
      },
      notifier = {},
      indent = {},
      bigfile = {},
      input = {},
      scope = {},
      dashboard = {
        preset = {
          header = [[
(( ))
( 0 0)    "ghost offers fragile
///> 🌸-  flower do you take?"
 v v       (y/n)]],
        },
        formats = {
          header = { "%s", align = "left" },
        },
        width = 30,
        sections = {
          { section = "header" },
          -- {
          --   title = "Task Warrior",
          --   icon = "󰓥",
          --   height = 7,
          -- },
          { section = "startup" },
        },
      },
    },
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

  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },

  {
    "Wansmer/langmapper.nvim",
    lazy = false,
    priority = 1,

    config = function()
      require "configs.langmapper"
    end,
  },

  --- UI ---

  {
    "nvchad/ui",
    dependencies = { "nvim-tree/nvim-web-devicons", "nvchad/base46" },
    config = function()
      require "nvchad"
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

  --- other ---

  {
    "zk-org/zk-nvim",
    ft = { "markdown" },
    config = function()
      require("zk").setup {}
    end,
  },

  {
    "quarto-dev/quarto-nvim",
    dependencies = {
      "jmbuhr/otter.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "quarto", "rmd", "r" },
  },
}
