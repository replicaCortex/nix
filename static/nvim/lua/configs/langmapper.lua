require("langmapper").automapping { global = true, buffer = true }

local function escape(str)
  local escape_chars = [[;,."|\]]
  return vim.fn.escape(str, escape_chars)
end

local en = [[`qwertyuiop[]asdfghjkl;'zxcvbnm]]
local ru = [[ёйцукенгшщзхъфывапролджэячсмить]]
local en_shift = [[~QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>]]
local ru_shift = [[ËЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ]]

vim.opt.langmap = vim.fn.join({
  escape(ru_shift) .. ";" .. escape(en_shift),
  escape(ru) .. ";" .. escape(en),
}, ",")

require("leap.util")["get-input"] = function()
  local ok, ch = pcall(vim.fn.getcharstr)
  if ok and ch ~= vim.api.nvim_replace_termcodes("<esc>", true, false, true) then
    return require("langmapper.utils").translate_keycode(ch, "default", "ru")
  end
end

-- Map
local map = require("langmapper").map

map("n", "<leader>.", "gcc", { remap = true })
map("v", "<leader>.", "gc", { remap = true })

map("i", "<C-р>", "<Left>", {})
map("i", "<C-д>", "<Right>", {})
map("i", "<C-о>", "<Down>", {})
map("i", "<C-л>", "<Up>", {})

vim.keymap.set({ "n", "x", "o" }, "ы", "<Plug>(leap-forward)")
vim.keymap.set({ "n", "x", "o" }, "Ы", "<Plug>(leap-backward)")
