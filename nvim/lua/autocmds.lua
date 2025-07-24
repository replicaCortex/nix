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

-- linter

-- vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost" }, {
--   callback = function()
--     require("lint").try_lint()
--   end,
-- })

vim.api.nvim_create_user_command("CopyLspMessage", function()
  local msg = vim.diagnostic.get(0, { lnum = vim.fn.line "." - 1 })[1]
  if msg then
    vim.fn.setreg("+", msg.message)
    print "Diagnostic message copied to clipboard!"
  else
    print "No diagnostic message found."
  end
end, {})
