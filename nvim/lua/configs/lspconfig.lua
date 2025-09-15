local lspconfig = require "lspconfig"

local servers = {
  "basedpyright",
  -- NOTE: сыро
  -- "ty",

  "bashls",
  "texlab",
  "clangd",
  "lua_ls",
  "yamlls",
  "neocmake",

  -- https://github.com/sqls-server/sqls?tab=readme-ov-file
  -- "sqls",
}

if vim.lsp.inlay_hint then
  vim.lsp.inlay_hint.enable(true, { 0 })
end

lspconfig.clangd.setup {
  cmd = {
    "clangd",
    "--clang-tidy",
    "--header-insertion=never",
  },
}

vim.lsp.config("yamlls", {
  settings = {
    yaml = {
      schemas = {},
    },
  },
})

vim.lsp.enable(servers)

local signature_help = vim.lsp.buf.signature_help
vim.lsp.buf.signature_help = function(config)
  config = config or {}
  config.border = config.border or "rounded"
  config.title = ""
  return signature_help(config)
end

-- disable semanticTokens
local function on_init(client, _)
  if client.supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

local lua_lsp_settings = {
  Lua = {
    runtime = { version = "LuaJIT" },
    workspace = {
      library = {
        vim.fn.expand "$VIMRUNTIME/lua",
        vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
        "${3rd}/luv/library",
      },
    },
  },
}

if vim.lsp.config then
  vim.lsp.config("*", { capabilities = capabilities, on_init = on_init })
  vim.lsp.config("lua_ls", { settings = lua_lsp_settings })
  vim.lsp.enable "lua_ls"
else
  require("lspconfig").lua_ls.setup {
    capabilities = capabilities,
    on_init = on_init,
    settings = lua_lsp_settings,
  }
end

---

require "configs.diagnostic"
