require "nvchad.mappings"

-- add yours here

local map = require("langmapper").map
local mapd = vim.keymap.del
local ls = require "luasnip"

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
mapd({ "n" }, "<C-n>")

-- map({ "i", "s" }, "<C-n>", function()
--   ls.change_choice(1)
-- end)
-- map({ "i", "s" }, "<C-p>", function()
--   ls.change_choice(-1)
-- end)
-- map({ "i", "s" }, "<C-t>", function()
--   require "luasnip.extras.select_choice"()
-- end)

map(
  "n",
  "<leader>fi",
  "<cmd>lua require('image_embed').open_image_picker()<CR>",
  { desc = "telescope find and past image" }
)

map("n", "<leader>fu", "<cmd>Telescope undo<CR>", { desc = "telescope undo" })

map("n", "<leader>fd", "<cmd>Telescope diagnostics<CR>", { desc = "diagnostics list" })
map("n", "<leader>fj", "<cmd>Telescope jumplist<CR>", { desc = "jumplist" })
map("n", "/", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Curreent buffer find" })
map("n", "?", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Curreent buffer find" })
map("n", "gr", "<cmd>Telescope lsp_references<CR>", { desc = "LSP References" })
map("n", "<leader>fg", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })

map("n", "<leader>ih", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {})
  -- vim.cmd "lua require('symbol-usage').refresh()"
  vim.cmd "lua require('symbol-usage').toggle()"
end, { desc = "toggle inlay gint" })
