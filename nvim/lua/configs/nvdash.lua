-- ~/.config/nvim/lua/nvdash.lua ( or any file ! )

return function()
  local layout = {
    {
      multicolumn = true,
      pad = 3,
      content = "fit",
      { txt = "  Update [u]", hl = "changed", keys = "u", cmd = ":Lazy sync <cr>" },
      {
        txt = "  Plug [p]",
        hl = "nviminternalError",
        keys = "p",
        cmd = ":e ~/.config/nvim/lua/plugins.lua <cr>",
      },

      {
        txt = "󰅪  Snippents [s]",
        hl = "Added",
        keys = "s",
        cmd = ":e ~/.config/nvim/lua_snippets/ <cr>",
      },
    },

    {
      multicolumn = true,
      pad = 3,
      content = "fit",
      {
        txt = "",
        keys = "A",
        cmd = ":e foo.bar | startinsert",
      },

      {
        txt = "",
        keys = "a",
        cmd = ":e foo.bar | startinsert",
      },

      {
        txt = "  Lsp [l]",
        hl = "@lsp.type.function",
        keys = "l",
        cmd = ":e ~/.config/nvim/lua/configs/lspconfig.lua <cr>",
      },

      {
        txt = "  Conform [c]",
        keys = "c",
        cmd = ":e ~/.config/nvim/lua/configs/conform.lua <cr>",
      },

      {
        txt = "",
        keys = "i",
        cmd = ":e foo.bar | startinsert",
      },

      {
        txt = "",
        keys = "I",
        cmd = ":e foo.bar | startinsert",
      },
    },

    {
      txt = function()
        local stats = require("lazy").stats()
        local ms = math.floor(stats.startuptime) .. " ms"
        return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
      end,
      hl = "comment",
      content = "fit",
    },
  }

  return layout
end
