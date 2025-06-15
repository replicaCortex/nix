local fzf = require "fzf-lua"

require("fzf-lua").setup {
  hls = {
    normal = "Normal",
    preview_normal = "Normal",
    border = "Function",
    preview_border = "Function",
  },
  winopts = {
    height = 0.55,
    width = 0.8,
    row = 0.5,
    -- preview = { hidden = "hidden" },
    border = "rounded",
    treesitter = { enabled = true },
  },
  fzf_opts = {
    ["--no-info"] = "",
    ["--info"] = "hidden",
    -- ["--padding"] = "13%,5%,13%,5%",
    ["--header"] = " ",
    ["--no-scrollbar"] = "",
  },
  files = {
    formatter = "path.filename_first",
    git_icons = false,
    no_header = true,
    cwd_header = false,
    cwd_prompt = false,
    winopts = {
      title = " files 📑 ",
      title_pos = "center",
      title_flags = false,
    },
  },
  buffers = {
    formatter = "path.filename_first",
    no_header = true,
    fzf_opts = { ["--delimiter"] = " ", ["--with-nth"] = "-1.." },
    winopts = {
      title = " buffers 📝 ",
      title_pos = "center",
    },
  },
  git = {
    branches = {
      cmd = "git branch -a --format='%(refname:short)'",
      no_header = true,
      winopts = {
        title = " branches  ",
        title_pos = "center",
        preview = { hidden = "hidden" },
      },
    },
  },
}

-- Keymaps
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<leader>ff", "<cmd>FzfLua files<cr>", opts)
keymap("n", "<leader>аа", "<cmd>FzfLua files<cr>", opts)
keymap("n", "<leader>fo", "<cmd>FzfLua oldfiles<cr>", opts)
keymap("n", "<leader>ащ", "<cmd>FzfLua oldfiles<cr>", opts)
keymap("n", "/", "<cmd>FzfLua blines<cr>", opts)
keymap("n", ".", "<cmd>FzfLua blines<cr>", opts)
keymap("n", "<leader>fw", "<cmd>FzfLua live_grep<cr>", opts)
keymap("n", "<leader>ац", "<cmd>FzfLua live_grep<cr>", opts)
keymap("n", "<leader>fb", "<cmd>FzfLua buffers<cr>", opts)
keymap("n", "<leader>аи", "<cmd>FzfLua buffers<cr>", opts)
keymap("n", "<leader>fg", "<cmd>FzfLua git_status<cr>", opts)
keymap("n", "<leader>ап", "<cmd>FzfLua git_status<cr>", opts)
keymap("n", "<leader>dd", "<cmd>FzfLua diagnostics_document<cr>", opts)
keymap("n", "<leader>вв", "<cmd>FzfLua diagnostics_document<cr>", opts)
keymap("n", "<leader>wd", "<cmd>FzfLua diagnostics_workspace<cr>", opts)
keymap("n", "<leader>цв", "<cmd>FzfLua diagnostics_workspace<cr>", opts)
