require "nvchad.autocmds"

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
