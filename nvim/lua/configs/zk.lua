require("zk").setup {
  picker = "snacks_picker",
}

local opts = { noremap = true, silent = false }
vim.api.nvim_set_keymap("n", "<leader>fz", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>ft", "<Cmd>ZkTags<CR>", opts)
