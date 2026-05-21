local opt = vim.opt
local o = vim.o
local g = vim.g

require("vim._core.ui2").enable()

g.loaded_node_provider = 0
g.loaded_perl_provider = 0
g.loaded_python_provider = 0
g.loaded_ruby_provider = 0
g.markdown_recommended_style = 0
o.clipboard = "unnamedplus"
o.cursorline = true
o.cursorlineopt = "both"
o.expandtab = true
o.ignorecase = true
o.inccommand = "nosplit"
o.laststatus = 3
o.list = true
o.mouse = ""
o.number = true
o.numberwidth = 2
o.relativenumber = true
o.ruler = false
o.shiftwidth = 2
o.showmode = false
o.sidescrolloff = 8
o.signcolumn = "yes"
o.smartcase = true
o.smartindent = true
o.softtabstop = 2
o.splitbelow = true
o.splitkeep = "screen"
o.splitright = true
o.swapfile = false
o.tabstop = 2
o.termguicolors = true
o.timeoutlen = 400
o.title = true
o.undofile = true
o.undolevels = 10000
o.updatetime = 250
o.virtualedit = "block"
o.winborder = "single"
opt.fillchars = { eob = " " }
opt.fillchars = { foldopen = "", foldclose = "", fold = " ", foldsep = " ", diff = "╱", eob = " " }
opt.whichwrap:append "<>[]hl"
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.shortmess:append "cI"

local keys = { ",", ".", "!", "?", ";", ":" }
for _, key in ipairs(keys) do
  vim.keymap.set("i", key, key .. "<C-g>u", { desc = "Undo Breakpoint" })
end
