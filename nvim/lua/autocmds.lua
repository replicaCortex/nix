vim.api.nvim_create_autocmd("CmdlineEnter", {
  callback = function()
    local cmd = [[niri msg -j keyboard-layouts | jq '.current_idx']]
    local handle = io.popen(cmd)
    if not handle then
      return
    end

    local layout = vim.trim(handle:read "a")
    handle:close()

    if layout == "1" then
      io.popen([[niri msg action switch-layout next]]):close()
    end

    _G.LAYOUT = layout
  end,
})

vim.api.nvim_create_autocmd("CmdlineLeave", {
  callback = function()
    if _G.LAYOUT == "1" then
      io.popen([[niri msg action switch-layout next]]):close()
    end
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 then
      require("snacks.picker").files()
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    -- ???
    vim.cmd [[set fo-=o]]
  end,
})

local progress = vim.defaulttable()
vim.api.nvim_create_autocmd("LspProgress", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params.value
    if not client or type(value) ~= "table" then
      return
    end
    local p = progress[client.id]

    for i = 1, #p + 1 do
      if i == #p + 1 or p[i].token == ev.data.params.token then
        p[i] = {
          token = ev.data.params.token,
          msg = ("[%3d%%] %s%s"):format(
            value.kind == "end" and 100 or value.percentage or 100,
            value.title or "",
            value.message and (" **%s**"):format(value.message) or ""
          ),
          done = value.kind == "end",
        }
        break
      end
    end

    local msg = {}
    progress[client.id] = vim.tbl_filter(function(v)
      return table.insert(msg, v.msg) or not v.done
    end, p)

    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    vim.notify(table.concat(msg, "\n"), "info", {
      id = "lsp_progress",
      title = client.name,
      opts = function(notif)
        notif.icon = #progress[client.id] == 0 and " "
          or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

--- auto compile ---

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "main.typ",
  callback = function()
    local file = vim.fn.expand "%"
    vim.system { "typst", "compile", file }
  end,
})

-- vim.api.nvim_create_autocmd("BufEnter", {
--   pattern = { "*.md", "*.typ", "*.tex", "*.txt" },
--   callback = function()
--     local opts = { noremap = true, silent = true, buffer = true }
--
--     vim.keymap.set("n", "j", "gj", opts)
--     vim.keymap.set("n", "k", "gk", opts)
--     vim.keymap.set("n", "0", "g0", opts)
--     vim.keymap.set("n", "$", "g$", opts)
--     vim.keymap.set("n", "^", "g^", opts)
--   end,
-- })
