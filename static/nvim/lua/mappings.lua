require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local mapd = vim.keymap.del

-- map("n", ";", ":", { desc = "CMD enter command mode" })
-- map("i", "jk", "<ESC>")

map({ "n" }, "q:", "<nop>")
map({ "n" }, "U", "<C-r>")
map({ "n" }, "q", "<nop>")
map({ "n" }, "Q", "<nop>")

map({ "n" }, "n", "<nop>")
map({ "n" }, "N", "<nop>")

mapd({ "t" }, "<C-x>")

mapd({ "n" }, "<leader>fm")
mapd({ "n" }, "<leader>h")
mapd({ "n" }, "<leader>v")
mapd({ "n" }, "<A-h>")
mapd({ "n" }, "<A-v>")
mapd({ "n" }, "<A-i>")
mapd({ "n" }, "<leader>n")
mapd({ "n" }, "<leader>rn")
mapd({ "n" }, "<leader>ch")

local ls = require "luasnip"

map({ "i", "s" }, "<C-n>", function()
  ls.change_choice(1)
end)
map({ "i", "s" }, "<C-p>", function()
  ls.change_choice(-1)
end)
map({ "i", "s" }, "<C-t>", function()
  require "luasnip.extras.select_choice"()
end)
