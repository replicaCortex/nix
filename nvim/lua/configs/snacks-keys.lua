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

  {
    "/",
    function()
      require("snacks.picker").lines {
        layout = {
          preview = "preview",
          preset = "dropdown",
        },
      }
    end,
  },
  {
    "?",
    function()
      require("snacks.picker").lines {
        layout = {
          preview = "preview",
          preset = "dropdown",
        },
      }
    end,
  },
  {
    ",",
    function()
      require("snacks.picker").lines {
        layout = {
          preview = "preview",
          preset = "dropdown",
        },
      }
    end,
  },
  {
    ".",
    function()
      require("snacks.picker").lines {
        layout = {
          preview = "preview",
          preset = "dropdown",
        },
      }
    end,
  },
  {
    "<leader>gb",
    function()
      require("snacks.picker").git_branches()
    end,
    desc = "Git Branches",
  },
  {
    "<leader>gl",
    function()
      require("snacks.picker").git_log()
    end,
    desc = "Git Log",
  },
  {
    "<leader>gL",
    function()
      require("snacks.picker").git_log_line()
    end,
    desc = "Git Log Line",
  },
  {
    "<leader>gs",
    function()
      require("snacks.picker").git_status()
    end,
    desc = "Git Status",
  },
  {
    "<leader>gS",
    function()
      require("snacks.picker").git_stash()
    end,
    desc = "Git Stash",
  },
  {
    "<leader>gd",
    function()
      require("snacks.picker").git_diff()
    end,
    desc = "Git Diff (Hunks)",
  },
  {
    "<leader>gf",
    function()
      require("snacks.picker").git_log_file()
    end,
    desc = "Git Log File",
  },

  --- terminal ---
  {
    "<leader>tt",
    function()
      require("snacks.terminal").toggle()
    end,
    desc = "Git Log File",
  },
  {
    "<leader>tl",
    function()
      require("snacks.terminal").list()
    end,
    desc = "Git Log File",
  },
  {
    "<leader>to",
    function()
      require("snacks.terminal").open()
    end,
    desc = "Git Log File",
  },
}
