local ls = require "luasnip"

require("luasnip.loaders.from_lua").load {
  paths = vim.fn.stdpath "config" .. "/snips/",
}

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

local select_next = false
map({ "i" }, "<C-;>", function()
  -- the meat of this mapping: call ls.activate_node.
  -- strict makes it so there is no fallback to activating any node in the
  -- snippet, and select controls whether the text associated with the node is
  -- selected.
  local ok, _ = pcall(ls.activate_node, {
    strict = true,
    -- select_next is initially unset, but set within the first second after
    -- activating the mapping, so activating it again in that timeframe will
    -- select the text of the found node.
    select = select_next,
  })
  -- ls.activate_node throws on failure.
  if not ok then
    print "No node."
    return
  end

  -- once the node is activated, we are either done (if text is SELECTed), or
  -- we briefly highlight the text associated with the node so one can know
  -- which node was activated.
  -- TODO: this highlighting does not show up if the node has no text
  -- associated (ie ${1:asdf} vs $1), a cool extension would be to also show
  -- something if there was no text.
  if select_next then
    return
  end

  local curbuf = vim.api.nvim_get_current_buf()
  local hl_duration_ms = 100

  local node = ls.session.current_nodes[curbuf]
  -- get node-position, raw means we want byte-columns, since those are what
  -- nvim_buf_set_extmark expects.
  local from, to = node:get_buf_position { raw = true }

  -- highlight snippet for 1000ms
  local id = vim.api.nvim_buf_set_extmark(curbuf, ls.session.ns_id, from[1], from[2], {
    -- one line below, at col 0 => entire last line is highlighted.
    end_row = to[1],
    end_col = to[2],
    hl_group = "Visual",
  })
  -- disable highlight by removing the extmark after a short wait.
  vim.defer_fn(function()
    vim.api.nvim_buf_del_extmark(curbuf, ls.session.ns_id, id)
  end, hl_duration_ms)

  -- set select_next for the next second.
  select_next = true
  vim.uv.new_timer():start(1000, 0, function()
    select_next = false
  end)
end)
