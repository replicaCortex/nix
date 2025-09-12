return {
  {
    "kevinhwang91/nvim-hlslens",
    keys = {
      { "/" },
      { "?" },
    },
    config = function()
      require "configs.hlslens"
    end,
  },

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
    event = { "BufReadPost", "BufNewFile", "BufEnter" },
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = { char = "│" },
      scope = { char = "│" },
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
          require "configs.luasnip"
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
    priority = 1, -- High priority is needed if you will use `autoremap()`

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
    "lervag/vimtex",
    ft = { "tex" },
    config = function()
      vim.g.vimtex_view_method = "zathura"
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

  -- {
  --   "R-nvim/R.nvim",
  --   ft = { "R", "rmd", "quarto" },
  -- },
}
