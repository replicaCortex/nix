local Snacks = require "snacks"

return {
  {
    "<leader>fi",
    function()
      Snacks.picker.icons()
    end,
    desc = "Icons",
  },
  {
    "<leader>sH",
    function()
      Snacks.picker.highlights()
    end,
    desc = "Highlights",
  },
  {
    "<leader>ff",
    function()
      Snacks.picker.files()
    end,
    desc = "Files",
  },
  {
    "<leader>fg",
    function()
      Snacks.picker.grep()
    end,
    desc = "Grep Workspace",
  },
  {
    "<leader>fd",
    function()
      Snacks.picker.diagnostics_buffer()
    end,
    desc = "Buffer Diagnostics",
  },
  {
    "<leader>fD",
    function()
      Snacks.picker.diagnostics()
    end,
    desc = "Workspace Diagnostics",
  },
  {
    "<leader>fu",
    function()
      Snacks.picker.undo()
    end,
    desc = "Undo History",
  },
  {
    "<C-n>",
    function()
      Snacks.explorer()
    end,
    desc = "Explorer",
  },
  {
    "<leader>fo",
    function()
      Snacks.picker.recent()
    end,
    desc = "Recent Files",
  },
  {
    "<leader>h",
    function()
      Snacks.picker.help()
    end,
    desc = "Help Pages",
  },
  {
    "grr",
    function()
      Snacks.picker.lsp_references()
    end,
    desc = "LSP References",
  },
  {
    "gd",
    function()
      Snacks.picker.lsp_definitions()
    end,
    desc = "LSP Definitions",
  },
  {
    "<leader>fw",
    function()
      Snacks.picker.grep_word()
    end,
    desc = "Visual selection or word",
    mode = { "n", "x" },
  },
  {
    "<leader>fb",
    function()
      Snacks.picker.buffers()
    end,
    desc = "Buffers",
  },
  {
    "<leader>fs",
    function()
      Snacks.picker.lsp_symbols()
    end,
    desc = "LSP Symbols",
  },
  {
    "<leader>fS",
    function()
      Snacks.picker.lsp_workspace_symbols()
    end,
    desc = "LSP Workspace Symbols",
  },
  {
    "<leader>fn",
    function()
      Snacks.picker.notifications()
    end,
    desc = "Notifications",
  },
  {
    "<leader>fh",
    function()
      Snacks.picker.command_history()
    end,
    desc = "Command History",
  },
  {
    "/",
    function()
      Snacks.picker.lines { layout = { preview = "preview", preset = "dropdown" } }
    end,
    desc = "Search Lines (/)",
  },
  {
    "?",
    function()
      Snacks.picker.lines { layout = { preview = "preview", preset = "dropdown" } }
    end,
    desc = "Search Lines Reverse (?)",
  },
  {
    ",",
    function()
      Snacks.picker.lines { layout = { preview = "preview", preset = "dropdown" } }
    end,
    desc = "Search Lines (,)",
  },
  {
    ".",
    function()
      Snacks.picker.lines { layout = { preview = "preview", preset = "dropdown" } }
    end,
    desc = "Search Lines (.)",
  },
  {
    "<leader>gb",
    function()
      Snacks.picker.git_branches()
    end,
    desc = "Git Branches",
  },
  {
    "<leader>gl",
    function()
      Snacks.picker.git_log()
    end,
    desc = "Git Log",
  },
  {
    "<leader>gL",
    function()
      Snacks.picker.git_log_line()
    end,
    desc = "Git Log Line",
  },
  {
    "<leader>gs",
    function()
      Snacks.picker.git_status()
    end,
    desc = "Git Status",
  },
  {
    "<leader>gS",
    function()
      Snacks.picker.git_stash()
    end,
    desc = "Git Stash",
  },
  {
    "<leader>gd",
    function()
      Snacks.picker.git_diff()
    end,
    desc = "Git Diff (Hunks)",
  },
  {
    "<leader>gf",
    function()
      Snacks.picker.git_log_file()
    end,
    desc = "Git Log File",
  },
  -- {
  --   "<C-t>",
  --   function()
  --     -- local active_pickers = Snacks.picker.main()
  --     --
  --     -- active_pickers:close()
  --
  --     Snacks.terminal.toggle()
  --   end,
  --   desc = "Toggle Terminal",
  --   mode = { "n", "t" },
  -- },
}
