require("conform").setup {
  formatters_by_ft = {
    lua = { "stylua" },
    sh = { "shfmt" },
    python = { "ruff_format", "ruff_organize_imports" },
    css = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    markdown = { "prettier" },
    json = { "prettier" },
    jsonc = { "prettier" },
    c = { "clang-format" },
    rust = { "rustfmt" },
  },
  format_on_save = {
    lsp_format = "fallback",
    timeout_ms = 500,
  },
}
