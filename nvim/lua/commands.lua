if vim.env.SSH_TTY then
  local function copy(lines, _)
    local content = table.concat(lines, "\n")
    local osc52 = string.format("\x1b]52;c;%s\x07", base64.encode(content))
    io.write(osc52)
  end

  local function paste()
    return {vim.fn.split(vim.fn.getreg('"'), "\n"), vim.fn.getregtype('"')}
  end
  
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
      ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
      ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
      ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
    },
  }
end
