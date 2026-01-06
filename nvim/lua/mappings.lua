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

vim.api.nvim_create_user_command("W", ":w", { desc = "I can't type :w without typing :W !" })
vim.api.nvim_create_user_command("Wa", ":wa", { desc = "I can't type :wa without typing :Wa !" })
vim.api.nvim_create_user_command("Wq", ":wq", { desc = "I can't type :wq without typing :Wq !" })
vim.api.nvim_create_user_command("Wqa", ":wqa", { desc = "I can't type :wqa without typing :Waq !" })
vim.api.nvim_create_user_command("Q", ":q", { desc = "I can't type :q without typing :Q !" })
vim.api.nvim_create_user_command("Wall", ":wall", { desc = "I can't type :wall without typing :Wall !" })

-- map("t", "<C-h>", [[<Cmd>wincmd h<CR>]])
map("t", "<C-j>", [[<Cmd>wincmd j<CR>]])
map("t", "<C-k>", [[<Cmd>wincmd k<CR>]])
-- map("t", "<C-l>", [[<Cmd>wincmd l<CR>]])
