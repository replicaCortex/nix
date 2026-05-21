local servers = {
  "bashls",
  "tailwindcss",
  "clangd",
  "gopls",
  "fish_lsp",
  "just",
  "cssls",
  "lua_ls",
  "nil_ls",
  "rust_analyzer",
  "tinymist",
  "ty",
  "ts_ls",
  "vscode-html-language-server",
}

if vim.lsp.inlay_hint then
  vim.lsp.inlay_hint.enable(true, { 0 })
end

vim.lsp.config("clangd", {
  cmd = {
    "clangd",
    "--clang-tidy",
    "--header-insertion=never",
  },
})

vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      check = { command = "clippy" },
    },
  },
})

vim.lsp.config("gopls", {
  settings = {
    gopls = {
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      codelenses = {
        generate = true,
        test = true,
        benchmark = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },
    },
  },
})

-- disable semanticTokens
local function on_init(client, _)
  if client:supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
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
vim.lsp.enable("html", true)
-- vim.lsp.codelens.enable(true)

require "configs.diagnostic"
