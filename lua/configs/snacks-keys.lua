return {
  {
    "<leader>fi",
    function()
      require("snacks.picker").icons()
    end,
    desc = "Icons",
  },
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
    desc = "Files",
  },
  {
    "<leader>fg",
    function()
      require("snacks.picker").grep()
    end,
    desc = "Grep Workspace",
  },
  {
    "<leader>fd",
    function()
      require("snacks.picker").diagnostics_buffer()
    end,
    desc = "Buffer Diagnostics",
  },
  {
    "<leader>fD",
    function()
      require("snacks.picker").diagnostics()
    end,
    desc = "Workspace Diagnostics",
  },
  {
    "<leader>fu",
    function()
      require("snacks.picker").undo()
    end,
    desc = "Undo History",
  },
  {
    "<C-n>",
    function()
      require("snacks.picker").explorer()
    end,
    desc = "Explorer",
  },
  {
    "<leader>fo",
    function()
      require("snacks.picker").recent()
    end,
    desc = "Recent Files",
  },
  {
    "<leader>h",
    function()
      require("snacks.picker").help()
    end,
    desc = "Help Pages",
  },
  {
    "grr",
    function()
      require("snacks.picker").lsp_references()
    end,
    desc = "LSP References",
  },
  {
    "gd",
    function()
      require("snacks.picker").lsp_definitions()
    end,
    desc = "LSP Definitions",
  },
  {
    "<leader>fw",
    function()
      require("snacks.picker").grep_word()
    end,
    desc = "Visual selection or word",
    mode = { "n", "x" },
  },
  {
    "<leader>fb",
    function()
      require("snacks.picker").buffers()
    end,
    desc = "Buffers",
  },
  {
    "<leader>fs",
    function()
      require("snacks.picker").lsp_symbols()
    end,
    desc = "LSP Symbols",
  },
  {
    "<leader>fS",
    function()
      require("snacks.picker").lsp_workspace_symbols()
    end,
    desc = "LSP Workspace Symbols",
  },
  {
    "<leader>fn",
    function()
      require("snacks.picker").notifications()
    end,
    desc = "Notifications",
  },
  {
    "<leader>fh",
    function()
      require("snacks.picker").command_history()
    end,
    desc = "Command History",
  },
  {
    "/",
    function()
      require("snacks.picker").lines { layout = { preview = "preview", preset = "dropdown" } }
    end,
    desc = "Search Lines (/)",
  },
  {
    "?",
    function()
      require("snacks.picker").lines { layout = { preview = "preview", preset = "dropdown" } }
    end,
    desc = "Search Lines Reverse (?)",
  },
  {
    ",",
    function()
      require("snacks.picker").lines { layout = { preview = "preview", preset = "dropdown" } }
    end,
    desc = "Search Lines (,)",
  },
  {
    ".",
    function()
      require("snacks.picker").lines { layout = { preview = "preview", preset = "dropdown" } }
    end,
    desc = "Search Lines (.)",
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
  {
    "<leader>tt",
    function()
      require("snacks.terminal").toggle()
    end,
    desc = "Toggle Terminal",
  },
  {
    "<leader>tl",
    function()
      require("snacks.terminal").list()
    end,
    desc = "List Terminals",
  },
  {
    "<leader>to",
    function()
      require("snacks.terminal").open()
    end,
    desc = "Open Terminal",
  },
}
