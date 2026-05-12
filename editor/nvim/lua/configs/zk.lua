require("zk").setup {
  picker = "snacks_picker",
}

local opts_notes = { noremap = true, silent = false, desc = "Zk Notes" }
vim.api.nvim_set_keymap("n", "<leader>fz", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", opts_notes)

local opts_tags = { noremap = true, silent = false, desc = "Zk Tags" }
vim.api.nvim_set_keymap("n", "<leader>ft", "<Cmd>ZkTags<CR>", opts_tags)
