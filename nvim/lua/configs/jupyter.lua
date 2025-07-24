require("neopyter").setup {}

local map = vim.keymap.set

map("n", "<leader>nr", "<cmd>Neopyter run current<CR>", { desc = "Run cell current" })
