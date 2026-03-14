local servers = {
  "bashls",
  "clangd",
  "fish_lsp",
  "just",
  "lua_ls",
  "neocmake",
  "nil_ls",
  "omnisharp",
  "rust_analyzer",
  "tinymist",
  "ty",
}

if vim.lsp.inlay_hint then
  vim.lsp.inlay_hint.enable(true, { 0 })
end

vim.lsp.config("clangd", {
  cmd = {
    "--clang-tidy",
    "--header-insertion=never",
    "clangd",
  },
})

vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      check = {
        command = "clippy",
      },
    },
  },
})

-- disable semanticTokens
local function on_init(client, _)
  -- if client.supports_method "textDocument/semanticTokens" then
  --   client.server_capabilities.semanticTokensProvider = nil
  -- end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  commitCharactersSupport = true,
  deprecatedSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  preselectSupport = true,
  snippetSupport = true,
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

vim.lsp.config("*", { capabilities = capabilities, on_init = on_init })
vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  on_init = on_init,
  settings = lua_lsp_settings,
})

vim.lsp.enable(servers)

require "configs.diagnostic"
