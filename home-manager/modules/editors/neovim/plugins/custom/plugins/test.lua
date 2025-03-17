noice.setup({
	cmdline = {
		enabled = true,
		view = "cmdline_popup",
		opts = {},
		format = {
			cmdline = { pattern = "^:", icon = "󰥻 ", lang = "vim" },
			search_down = { kind = "search", pattern = "^/", icon = "", lang = "regex" },
			search_up = { kind = "search", pattern = "^%?", icon = "", lang = "regex" },
			filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
			lua = {
				pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" },
				icon = "",
				lang = "lua",
			},
			help = { pattern = "^:%s*he?l?p?%s+", icon = "󰋖 " },
			input = { view = "cmdline_input", icon = "󰿟 " },
		},
	},
	redirect = {
		view = "popup",
		filter = { event = "msg_show" },
	},
	commands = {
		history = {
			view = "split",
			opts = { enter = true, format = "details" },
			filter = {
				any = {
					{ event = "notify" },
					{ error = true },
					{ warning = true },
					{ event = "msg_show", kind = { "" } },
					{ event = "lsp", kind = "message" },
				},
			},
		},
		last = {
			view = "popup",
			opts = { enter = true, format = "details" },
			filter = {
				any = {
					{ event = "notify" },
					{ error = true },
					{ warning = true },
					{ event = "msg_show", kind = { "" } },
					{ event = "lsp", kind = "message" },
				},
			},
			filter_opts = { count = 1 },
		},
		errors = {
			view = "popup",
			opts = { enter = true, format = "details" },
			filter = { error = true },
			filter_opts = { reverse = true },
		},
		all = {
			view = "split",
			opts = { enter = true, format = "details" },
			filter = {},
		},
	},
	presets = {
		bottom_search = false,
		command_palette = false,
		long_message_to_split = false,
		inc_rename = false,
		lsp_doc_border = false,
	},
	views = {
		cmdline_popup = {
			position = { row = 15, col = "50%" },
			size = { width = 60, height = "auto" },
		},
		popupmenu = {
			enable = true,
			backend = "cmp",
			relative = "editor",
			position = { row = 8, col = "50%" },
			size = { width = 60, height = 10 },
			border = { style = "rounded", padding = { 0, 1 } },
			style = "minimal",
			scrollbar = false,
			winhighlight = {
				Normal = "Pmenu",
				FloatBorder = "PmenuBorder",
				CursorLine = "Visual",
			},
			win_options = {
				winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
			},
		},
	},
	-- routes = {
	--     {
	--         view = "popupmenu",
	--         filter = {
	--             any = {
	--                 { event = "menu" },
	--                 { event = "popupmenu" },
	--                 { event = "popupmenu_show" },
	--             },
	--         },
	--     },
	-- },
	status = {},
	format = {},
})
