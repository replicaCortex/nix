local map = vim.keymap.set
-- local mapd = vim.keymap.del

-- map("i", "<C-h>", "<Left>")
-- map("i", "<C-l>", "<Right>")
-- map("i", "<C-j>", "<Down>")
-- map("i", "<C-k>", "<Up>")

map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")

map("n", "<Esc>", "<cmd>noh<CR>")

map("n", "<leader>/", "gcc", { remap = true })
map("v", "<leader>/", "gc", { remap = true })

-- map("c", "<TAB>", "")
-- map("n", "q:", "")

-- mapd("n", "q")
-- mapd("n", "Q")

vim.api.nvim_create_user_command("W", ":w", {})
vim.api.nvim_create_user_command("Wa", ":wa", {})
vim.api.nvim_create_user_command("Wq", ":wq", {})
vim.api.nvim_create_user_command("Wqa", ":wqa", {})
vim.api.nvim_create_user_command("Q", ":q", {})
vim.api.nvim_create_user_command("Wall", ":wall", {})

-- map("t", "<C-h>", [[<Cmd>wincmd h<CR>]])
map("t", "<C-j>", [[<Cmd>wincmd j<CR>]])
map("t", "<C-k>", [[<Cmd>wincmd k<CR>]])
map("i", "<C-j>", "<Esc><C-w>j")
-- map("t", "<C-l>", [[<Cmd>wincmd l<CR>]])

map("n", "<Up>", "<Nop>")
map("n", "<Down>", "<Nop>")
map("n", "<Left>", "<Nop>")
map("n", "<Right>", "<Nop>")

map("i", "<C-k>", function()
  vim.lsp.buf.signature_help()
end)
