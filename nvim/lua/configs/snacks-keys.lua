return {
  {
    "<leader>sH",
    function()
      require("snacks.picker").highlights()
    end,
    desc = "Highlights",
  },
  {
    "<leader>ff",
    function()
      require("snacks.picker").files()
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
    "<leader>fD",
    function()
      require("snacks.picker").diagnostics()
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
    "<leader>fS",
    function()
      require("snacks.picker").lsp_workspace_symbols()
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

  -- {
  --   "/",
  --   function()
  --     require("snacks.picker").lines {
  --       layout = {
  --         preview = "preview",
  --         preset = "dropdown",
  --       },
  --     }
  --   end,
  -- },
  -- {
  --   "?",
  --   function()
  --     require("snacks.picker").lines {
  --       layout = {
  --         preview = "preview",
  --         preset = "dropdown",
  --       },
  --     }
  --   end,
  -- },
  -- {
  --   ",",
  --   function()
  --     require("snacks.picker").lines {
  --       layout = {
  --         preview = "preview",
  --         preset = "dropdown",
  --       },
  --     }
  --   end,
  -- },
  -- {
  --   ".",
  --   function()
  --     require("snacks.picker").lines {
  --       layout = {
  --         preview = "preview",
  --         preset = "dropdown",
  --       },
  --     }
  --   end,
  -- },
}
