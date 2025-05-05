local function on_attach(client, bufnr)
	if client.server_capabilities.inlayHintProvider then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

		vim.keymap.set("n", "<localleader>ih", function()
			local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
			vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
		end, {
			buffer = bufnr,
		})
	end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
-- на всякий случай явно включим
capabilities.textDocument.completion.completionItem.snippetSupport = true
-- to define small helper and utility functions so you don't have to repeat yourself.
--
-- In this case, we create a function that lets us more easily define mappings specific
-- for LSP related items. It sets the mode, buffer and description for us each time.
-- local map = function(keys, func, desc)
--   vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
-- end

-- The following two autocommands are used to highlight references of the
-- word under the cursor when your cursor rests there for a little while.
--    See `:help CursorHold` for information about when this is executed
--
-- When you move your cursor, the highlights will be cleared (the second autocommand).
-- if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
--   local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
--   vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
--     buffer = bufnr,
--     group = highlight_augroup,
--     callback = vim.lsp.buf.document_highlight,
--   })
--
--   vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
--     buffer = bufnr,
--     group = highlight_augroup,
--     callback = vim.lsp.buf.clear_references,
--   })
--
--   vim.api.nvim_create_autocmd('LspDetach', {
--     group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
--     callback = function(event2)
--       vim.lsp.buf.clear_references()
--       vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
--     end,
--   })
-- end
--
-- -- The following autocommand is used to enable inlay hints in your
-- -- code, if the language server you are using supports them
-- --
-- -- This may be unwanted, since they displace some of your code

-- require("lspconfig")["pyright"].setup({
--     on_attach = on_attach,
--     capabilities = capabilities,
--     settings = {
--         python = {
--             analysis = {
--                 diagnosticSeverityOverrides = {
--                     reportUnusedExpression = "none",
--                 },
--             },
--         },
--     },
-- })

require("lspconfig")["basedpyright"].setup({
	on_attach = on_attach,
	-- capabilities = capabilities,
	settings = {
		python = {
			analysis = {
				inlayHints = true,
				diagnosticSeverityOverrides = {
					reportUnusedExpression = "none",
				},
			},
		},
	},
})

require("lspconfig").texlab.setup({
	enable = true,
	capabilities = capabilities,
})
