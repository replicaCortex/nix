require("nvchad.configs.lspconfig").defaults()

local servers = {
  "basedpyright",
  -- NOTE: сыро
  -- "ty",

  "bashls",
  "texlab",
  "clangd",

  -- https://github.com/sqls-server/sqls?tab=readme-ov-file
  -- "sqls",
}

if vim.lsp.inlay_hint then
  vim.lsp.inlay_hint.enable(true, { 0 })
end

vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
