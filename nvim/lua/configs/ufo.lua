local o = vim.opt
local k = vim.keymap

o.foldenable = true
o.foldcolumn = "0"
o.foldlevel = 99
o.foldlevelstart = 99
o.foldexpr = "v:lua.vim.treesitter.foldexpr()"

k.set("n", "zR", require("ufo").openAllFolds)
k.set("n", "zM", require("ufo").closeAllFolds)

k.set("n", "K", function()
  local winid = require("ufo").peekFoldedLinesUnderCursor()
  if not winid then
    vim.lsp.buf.hover()
  end
end)

local handler = function(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = (" 󰁂 %d "):format(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, { suffix, "MoreMsg" })
  return newVirtText
end

require("ufo").setup {

  close_fold_kinds_for_ft = {
    default = { "imports", "comment" },
    json = { "array" },
    c = { "comment", "region" },
  },
  close_fold_current_line_for_ft = {
    default = true,
  },
  preview = { mappings = { switch = "K" } },
  fold_virt_text_handler = handler,
}
