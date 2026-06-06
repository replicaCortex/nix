return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    build = ":TSUpdate",
    opts = function()
      return require "configs.treesitter"
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
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "lewis6991/gitsigns.nvim" },
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
    "windwp/nvim-ts-autotag",
    ft = { "html", "javascript", "typescript", "javascriptreact", "typescriptreact", "vue", "xml", "twig" },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
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
  {
    "zk-org/zk-nvim",
    ft = { "markdown" },
    config = function()
      require "configs.zk"
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        { "<leader>f", group = "Find", icon = " " },
        { "<leader>g", group = "Git", icon = "󰊢 " },
        { "<leader>m", group = "Marks", icon = "󱙝 " },
        { "<leader>q", group = "Quickfix", icon = " " },
        { "<leader>t", group = "Terminal", icon = " " },
      },
    },
  },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      signs = true,
      sign_priority = 8,
      keywords = {
        FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      },
    },
    keys = {
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next Todo Comment",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous Todo Comment",
      },
      {
        "<leader>ft",
        function()
          require("snacks.picker").todo_comments { no_status = true }
        end,
        desc = "Find Todo Comments",
      },
    },
  },
}
