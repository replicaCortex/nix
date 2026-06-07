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

  format_on_save = function(bufnr)
    local bufname = vim.api.nvim_buf_get_name(bufnr)

    if bufname:match "qutebrowser%-editor" then
      return nil
    end

    return {
      lsp_format = "fallback",
      timeout_ms = 2000,
    }
  end,
}
