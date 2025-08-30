vim.api.nvim_create_autocmd("CmdlineEnter", {
  callback = function()
    local cmd =
      [[swaymsg -t get_inputs | jq -r '.[] | select(.type=="keyboard") | .xkb_active_layout_name' | tail -n 1]]
    local handle = io.popen(cmd)
    if not handle then
      return
    end

    local layout = vim.trim(handle:read "a")
    handle:close()

    if layout == "Russian" then
      io.popen([[swaymsg input "*" xkb_switch_layout next]]):close()
    end

    _G.LAYOUT = layout
  end,
})

vim.api.nvim_create_autocmd("CmdlineLeave", {
  callback = function()
    if _G.LAYOUT == "Russian" then
      io.popen([[swaymsg input "*" xkb_switch_layout next]]):close()
    end
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank {
      higroup = "IncSearch",
      timeout = 200,
    }
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    if vim.bo.filetype == "org" then
      return
    end
    local winid = vim.api.nvim_get_current_win()
    local method = vim.wo[winid].foldmethod
    if method == "diff" or method == "marker" then
      require("ufo").closeAllFolds()
      return
    end
    require "async"(function()
      local bufnr = vim.api.nvim_get_current_buf()
      require("ufo").attach(bufnr)
      local ranges = await(require("ufo").getFolds(bufnr, "treesitter") or {})
      local ok = require("ufo").applyFolds(bufnr, ranges)
      if ok then
        require("ufo").closeAllFolds()
      end
    end)
  end,
})
