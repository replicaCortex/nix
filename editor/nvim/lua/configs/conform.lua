require("conform").setup {
  formatters_by_ft = {
    lua = { "stylua" },
    sh = { "shfmt" },
    python = { "ruff_fix", "ruff_organize_imports", "ruff_format" },
    css = { "prettier" },
    html = { "prettier" },
    markdown = { "prettier" },
    json = { "prettier" },
    jsonc = { "prettier" },
    nix = { "nixfmt" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    javascript = { "prettier" },
    gdscript = { "gdscript-formatter" }
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
