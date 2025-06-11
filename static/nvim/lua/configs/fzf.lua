require("fzf-lua").setup {
  files = {
    color_icons = true,
    file_icons = true,
    find_opts = [[-type f -not -path '*.git/objects*' -not -path '*.env*']],
    multiprocess = true,
    prompt = "Files: ",
  },
  winopts = {
    border = "rounded",
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
