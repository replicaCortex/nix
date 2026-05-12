require("luasnip.loaders.from_lua").load { paths = vim.fn.stdpath "config" .. "/lua_snippets/" }

local map = vim.keymap.set

map({ "i", "s" }, "<A-l>", function()
  if vim.snippet.active { direction = 1 } then
    return "<Cmd>lua vim.snippet.jump(1)<CR>"
  else
    return "<A-l>"
  end
end, { expr = true, silent = true, desc = "Jump Next Snippet" })

map({ "i", "s" }, "<A-h>", function()
  if vim.snippet.active { direction = -1 } then
    return "<cmd>lua vim.snippet.jump(-1)<cr>"
  else
    return "<A-h>"
  end
end, { expr = true, silent = true, desc = "Jump Prev Snippet" })
