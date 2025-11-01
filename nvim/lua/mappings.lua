local map = vim.keymap.set
-- local mapd = vim.keymap.del

map("i", "<C-h>", "<Left>")
map("i", "<C-l>", "<Right>")
map("i", "<C-j>", "<Down>")
map("i", "<C-k>", "<Up>")

map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")

map("n", "<Esc>", "<cmd>noh<CR>")

map("n", "<leader>/", "gcc", { remap = true })
map("v", "<leader>/", "gc", { remap = true })

map("c", "<TAB>", "")
map("n", "q:", "")

-- mapd("n", "q")
-- mapd("n", "Q")
