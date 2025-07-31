local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    sh = { "shfmt" },
    nix = { "alejandra" },
    python = { "black" },
    css = { "prettier" },
    html = { "prettier" },
    c = { "clang-format" },
    -- sql = { "sql_formatter" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
