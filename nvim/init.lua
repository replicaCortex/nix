local function init_blink()
	local menu_cols = { { "label" }, { "kind_icon" }, { "kind" } }

	local kind = {
		Namespace = "󰌗",
		Text = "󰉿",
		Method = "󰆧",
		Function = "󰆧",
		Constructor = "󱌢",
		Field = "󰜢",
		Variable = "󰀫",
		Class = "󰠱",
		Interface = "",
		Module = "",
		Property = "󰜢",
		Unit = "󰑭",
		Value = "󰎠",
		Enum = "",
		Keyword = "󰌋",
		Snippet = "",
		Color = "󱓻",
		File = "󰈚",
		Reference = "󰈇",
		Folder = "󰉋",
		EnumMember = "",
		Constant = "󰏿",
		Struct = "󰙅",
		Event = "",
		Operator = "󰆕",
		TypeParameter = "󰊄",
		Table = "",
		Object = "󰅩",
		Tag = "",
		Array = "[]",
		Boolean = "",
		Number = "",
		Null = "󰟢",
		Supermaven = "",
		String = "󰉿",
		Calendar = "",
		Watch = "󰥔",
		Package = "",
		Copilot = "",
		Codeium = "",
		TabNine = "",
		BladeNav = "",
	}

	local opts = {
		-- snippets = { preset = "luasnip" },
		cmdline = {
			enabled = true,

			completion = {
				menu = {
					auto_show = true,
				},
				list = {
					selection = {
						preselect = true,
						auto_insert = false,
					},
				},
			},

			keymap = {
				preset = "default",
				["<CR>"] = { "accept", "fallback" },
				["<A-l>"] = { "snippet_forward", "fallback" },
				["<A-h>"] = { "snippet_backward", "fallback" },
			},
		},
		appearance = { nerd_font_variant = "normal" },
		fuzzy = { implementation = "prefer_rust" },
		sources = {
			default = { "lsp", "snippets", "buffer", "path" },
			providers = {
				cmdline = {
					min_keyword_length = function(ctx)
						if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
							return 3
						end
						return 0
					end,
				},
			},
		},

		keymap = {
			preset = "default",
			["<CR>"] = { "accept", "fallback" },
			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },
			["<A-l>"] = { "snippet_forward", "fallback" },
			["<A-h>"] = { "snippet_backward", "fallback" },
		},

		completion = {
			accept = { auto_brackets = { enabled = true } },
			ghost_text = { enabled = true },
			menu = {
				draw = {
					columns = menu_cols,
					components = {
						kind_icon = {
							text = function(ctx)
								local icons = kind
								local icon = (icons[ctx.kind] or "󰈚")

								return icon
							end,
						},
					},
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
			},
			list = {
				selection = {
					preselect = true,
					auto_insert = false,
				},
			},
		},
	}

	return opts
end

local function init_lsp()
	local servers = {
		"ty",
		"bashls",
		"texlab",
		"clangd",
		"lua_ls",
		"yamlls",
		"neocmake",
		"nil_ls",
		"tinymist",
		"rust_analyzer",
		"sqls",
		"taplo",
	}

	if vim.lsp.inlay_hint then
		vim.lsp.inlay_hint.enable(true, { 0 })
	end

	local function on_init(client, _)
		if client.supports_method("textDocument/semanticTokens") then
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

	vim.lsp.config("*", { capabilities = capabilities, on_init = on_init })

	vim.lsp.enable(servers)
end

--- settings
local g = vim.g
local opt = vim.opt

opt.laststatus = 3
opt.splitkeep = "screen"

opt.clipboard = "unnamedplus"
opt.cursorline = true
opt.cursorlineopt = "both"
opt.virtualedit = "block"
opt.title = true
opt.winborder = "single"

opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.tabstop = 2
opt.softtabstop = 2
opt.signcolumn = "yes"

opt.ignorecase = true
opt.smartcase = true
opt.mouse = "a"

opt.number = true
opt.numberwidth = 2
opt.relativenumber = true

opt.undofile = true

opt.updatetime = 250
opt.swapfile = false

opt.whichwrap:append("<>[]hl")
opt.fillchars = { eob = " " }

g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

--- keymap
vim.schedule(
	function()
		g.mapleader = " "
		g.maplocalleader = ";"

		local map = vim.keymap.set
		map("n", "<Esc>", "<cmd>noh<CR>")
		map("n", "<leader>/", "gcc", { remap = true })
		map("v", "<leader>/", "gc", { remap = true })

		map("i", "<C-h>", "<Left>")
		map("i", "<C-l>", "<Right>")
		map("i", "<C-j>", "<Down>")
		map("i", "<C-k>", "<Up>")

		map("n", "<C-h>", "<C-w>h")
		map("n", "<C-l>", "<C-w>l")
		map("n", "<C-j>", "<C-w>j")
		map("n", "<C-k>", "<C-w>k")

		map("n", "<leader>ff", ":Pick files<CR>")
		map("n", "<leader>h", ":Pick help<CR>")
	end,

	--- require
	---@diagnostic disable: missing-fields
	require("nvim-treesitter.configs").setup({
		ensure_installed = {
			"lua",

			"html",
			"css",

			"python",
			"nix",

			"c",
			"cpp",

			"make",
			"cmake",

			"r",
			"yaml",
			"rnoweb",
			"typst",

			"rust",

			"markdown",
			"markdown_inline",
		},

		highlight = {
			enable = true,
			use_languagetree = true,
			additional_vim_regex_highlighting = false,
		},

		indent = { enable = true },
	})
)

--- autocmd ---
local function is_plugin_available(name)
	local success, _ = pcall(require, name)
	return success
end

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.cmd([[set fo-=o]])
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 200,
		})
	end,
})

--- lazy load ---

local pairs_loaded = false
local blink_loaded = false

local function ensure_pairs_loaded()
	if not pairs_loaded then
		vim.cmd("packadd mini.pairs")
		require("mini.pairs").setup()
		pairs_loaded = true
	end
end

local function ensure_blink_loaded()
	if not blink_loaded then
		vim.cmd("packadd blink.cmp")
		require("blink.cmp").setup(init_blink())
		blink_loaded = true
	end
end

vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
	pattern = "*",
	callback = function(args)
		if args.event == "InsertEnter" then
			ensure_pairs_loaded()
			ensure_blink_loaded()
		elseif args.event == "CmdlineEnter" then
			ensure_blink_loaded()
		end
	end,
})

vim.api.nvim_create_autocmd("VimEnter", {
	pattern = { "*.lua", "*.rs", "*.typ", "*.txt", "*.c", "*.h", "*.cc", "*.hh", "*.py", "Cmake*.txt" },
	callback = function()
		init_lsp()
	end,
})

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*.typ", "*.tex", "*.md" },
	callback = function()
		if is_plugin_available("langmapper.nvim") == false then
			vim.cmd("packadd langmapper.nvim")
			require("langmapper").setup({
				layouts = {
					ru = {
						layout = nil,
						default_layout = nil,
					},
				},
			})

			local function escape(str)
				local escape_chars = [[;,."|\]]
				return vim.fn.escape(str, escape_chars)
			end

			local en = [[`qwertyuiop[]asdfghjkl;'zxcvbnm]]
			local ru = [[ёйцукенгшщзхъфывапролджэячсмить]]
			local en_shift = [[~QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>]]
			local ru_shift = [[ËЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ]]

			vim.opt.langmap = vim.fn.join({
				escape(ru_shift) .. ";" .. escape(en_shift),
				escape(ru) .. ";" .. escape(en),
			}, ",")

			require("langmapper").automapping({ global = true, buffer = true })
		end
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		if is_plugin_available("conform.nvim") == false then
			vim.cmd("packadd conform.nvim")
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					nix = { "alejandra" },
					sh = { "shfmt" },
					python = { "ruff_format", "ruff_organize_imports" },
					css = { "prettier" },
					html = { "prettier" },
					c = { "clang-format " },
					make = { "bake" },
					markdown = { "mdformat" },
					json = { "fixjson" },
					sql = { "sleek" },
					rust = { "rustfmt" },
					tex = { "latexindent" },
					typst = { "typstyle" },
				},
				format_on_save = {
					timeout_ms = 1000,
				},
				formatters = {
					mdformat = {
						append_args = { "--number " },
					},
					bake = {
						command = "mbake",
					},
				},
			})
		end
		require("conform").format({ bufnr = args.buf })
	end,
})

vim.cmd("colorscheme gruvbox")
require("mini.pick").setup()
