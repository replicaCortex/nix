require("hlslens").setup()
local hlslens = require "hlslens"

local kopts = { noremap = true, silent = true }
local vi = vim.api
local k = vim.keymap

local function nN(char)
  local ok, winid = hlslens.nNPeekWithUFO(char)
  if ok and winid then
    vim.keymap.set("n", "<CR>", function()
      return "<Tab><CR>"
    end, { buffer = true, remap = true, expr = true })
  end
end

k.set({ "n", "x" }, "n", function()
  nN "n"
end)
k.set({ "n", "x" }, "N", function()
  nN "N"
end)

vi.nvim_set_keymap("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vi.nvim_set_keymap("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
vi.nvim_set_keymap("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vi.nvim_set_keymap("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

vi.nvim_set_hl(0, "HlSearchLens", { link = "Visual" })
