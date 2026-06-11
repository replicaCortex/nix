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

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
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

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "main.typ",
  callback = function()
    local file = vim.fn.expand "%"
    vim.system { "typst", "compile", file }
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

local create_cmd = vim.api.nvim_create_user_command

create_cmd("TSInstallAll", function()
  local spec = require("lazy.core.config").plugins["nvim-treesitter"]
  local opts = type(spec.opts) == "table" and spec.opts or {}
  require("nvim-treesitter").install(opts.ensure_installed)
end, {})

vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    if
      require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
      and not require("luasnip").session.jump_active
    then
      require("luasnip").unlink_current()
    end
  end,
})

local is_minimal = os.getenv "NVIM_MINIMAL" == "1"

if not is_minimal then
  vim.schedule(function()
    local input = require "snacks.picker.core.input"
    local statuscolumn = input.statuscolumn
    input.statuscolumn = function(self)
      if self.picker.opts.no_status == true then
        return " "
      else
        return statuscolumn(self)
      end
    end
  end)
end

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile", "BufEnter" }, {
  pattern = { "*/inbox_*.txt", "/tmp/inbox*.txt" },
  callback = function()
    vim.cmd [[
      syntax clear

      syntax match InboxComment "^#.*"

      syntax match InboxPipe "|"

      syntax match InboxTags "^[^|#]\+\ze|"

      syntax match InboxType "|\s*\zs[a-zA-Z0-9_-]\+$"

      syntax match InboxFile "|\s*\zs[^|]\+\ze\s*|" contains=InboxHash,InboxExt

      syntax match InboxHash "_[a-f0-9]\{6,8}\ze\." contained

      syntax match InboxExt "\.[a-zA-Z0-9]\+" contained

      hi def link InboxComment Comment
      hi def link InboxPipe    Delimiter
      hi def link InboxTags    Identifier
      hi def link InboxFile    String
      hi def link InboxHash    Number
      hi def link InboxExt     Type
      hi def link InboxType    Statement
    ]]
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile", "BufEnter" }, {
  pattern = { "*/vidir_edit*", "/tmp/vidir_edit*" },
  callback = function()
    vim.cmd [[
      syntax clear

      syntax match VidirID "^\s*\d\+"
      
      syntax match VidirDir "\t\zs.*/"
      
      hi def link VidirID Number
      hi def link VidirDir Directory
    ]]
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile", "BufEnter" }, {
  pattern = "*qutebrowser-editor-*",
  callback = function()
    -- vim.bo.filetype = "markdown"
    vim.opt_local.linebreak = true
    vim.opt_local.spell = true
    vim.opt_local.spelllang = { "ru", "en" }
  end,
})
