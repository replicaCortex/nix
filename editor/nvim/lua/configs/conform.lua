local function distrobox_formatter(name)
  return {
    command = vim.fn.stdpath "config" .. "/distrobox-fmt.sh",
    prepend_args = { name },
  }
end

require("conform").setup {
  formatters_by_ft = {
    lua = { "stylua" },
    sh = { "shfmt" },
    python = { "ruff_format", "ruff_organize_imports" },
    css = { "prettier" },
    html = { "prettier" },
    c = { "clang-format" },
    markdown = { "prettier" },
    json = { "prettier" },
    jsonc = { "prettier" },
    rust = { "rustfmt" },
    nix = { "nixfmt" },
  },
  format_on_save = {
    lsp_format = "fallback",
    timeout_ms = 1000,
  },
  formatters = {
    stylua = distrobox_formatter "stylua",
    shfmt = distrobox_formatter "shfmt",
    ruff_format = distrobox_formatter "ruff",
    prettier = distrobox_formatter "prettier",
    ["clang-format"] = distrobox_formatter "clang-format",
    rustfmt = distrobox_formatter "rustfmt",
    nixfmt = distrobox_formatter "nixfmt",
  },
}
