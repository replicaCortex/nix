local map = vim.keymap.set

map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window" })

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "Clear Highlights" })

map("n", "<leader>/", "gcc", { remap = true, desc = "Toggle Comment Line" })
map("v", "<leader>/", "gc", { remap = true, desc = "Toggle Comment Selection" })

vim.api.nvim_create_user_command("W", ":w", {})
vim.api.nvim_create_user_command("Wa", ":wa", {})
vim.api.nvim_create_user_command("Wq", ":wq", {})
vim.api.nvim_create_user_command("Wqa", ":wqa", {})
vim.api.nvim_create_user_command("Q", ":q", {})
vim.api.nvim_create_user_command("Wall", ":wall", {})

map("t", "<C-j>", [[<Cmd>wincmd j<CR>]], { desc = "Go to Lower Window" })
map("t", "<C-k>", [[<Cmd>wincmd k<CR>]], { desc = "Go to Upper Window" })
map("i", "<C-j>", "<Esc><C-w>j", { desc = "Go to Lower Window" })

map("n", "<Up>", "<Nop>", { desc = "Disable Up Arrow" })
map("n", "<Down>", "<Nop>", { desc = "Disable Down Arrow" })
map("n", "<Left>", "<Nop>", { desc = "Disable Left Arrow" })
map("n", "<Right>", "<Nop>", { desc = "Disable Right Arrow" })

map("i", "<C-k>", function()
  vim.lsp.buf.signature_help()
end, { desc = "Signature Help" })

map("n", "]q", "<cmd>cnext<CR>zz", { desc = "Next Quickfix Item" })
map("n", "[q", "<cmd>cprev<CR>zz", { desc = "Prev Quickfix Item" })
map("n", "<leader>qq", "<cmd>copen<CR>", { desc = "Open Quickfix List" })
map("n", "<leader>qc", "<cmd>cclose<CR>", { desc = "Close Quickfix List" })
