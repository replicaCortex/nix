require("conform").setup {
  formatters_by_ft = {
    lua = { "stylua" },
    sh = { "shfmt" },
    cs = { "csharpier" },
    python = { "ruff_format", "ruff_organize_imports" },
    css = { "prettier" },
    html = { "prettier" },
    c = { "clang-format" },
    markdown = { "prettier" },
    json = { "prettier" },
    jsonc = { "prettier" },
    rust = { "rustfmt" },
    nix = { "nixfmt" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    javascript = { "prettier" },
    go = { "gofmt" },
  },
  format_on_save = {
    lsp_format = "fallback",
    timeout_ms = 2000,
  },
}
