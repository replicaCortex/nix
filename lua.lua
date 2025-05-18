-- Nixvim's internal module table
-- Can be used to share code throughout init.lua
local _M = {}

-- Set up globals {{{
do
  local nixvim_globals = { loaded_perl_provider = 0, loaded_ruby_provider = 0, mapleader = " ", maplocalleader = ";", undotree_CursorLine = true, undotree_DiffAutoOpen = true, undotree_DiffCommand = "diff", undotree_DiffpanelHeight = 10, undotree_HelpLine = true, undotree_HighlightChangedText = true, undotree_HighlightChangedWithSign = true, undotree_HighlightSyntaxAdd = "DiffAdd", undotree_HighlightSyntaxChange = "DiffChange", undotree_HighlightSyntaxDel = "DiffDelete", undotree_RelativeTimestamp = true, undotree_SetFocusWhenToggle = true, undotree_ShortIndicators = false, undotree_SplitWidth = 40, undotree_TreeNodeShape = "*", undotree_TreeReturnShape = "\\", undotree_TreeSplitShape = "/", undotree_TreeVertShape = "|", undotree_WindowLayout = 4, vimtex_callback_progpath = "nvim", vimtex_compiler_method = "lualatex", vimtex_enabled = true, vimtex_toc_config = { split_pos = "vert topleft", split_width = 40 }, vimtex_view_method = "zathura" }

  for k,v in pairs(nixvim_globals) do
    vim.g[k] = v
  end
end
-- }}}

-- Set up options {{{
do
  local nixvim_options = { autoindent = true, breakindent = true, clipboard = "unnamedplus", cursorline = true, cursorlineopt = "number", expandtab = true, fillchars = { diff = " ", eob = " ", fold = " ", foldclose = "-", foldopen = "~", horiz = "━", horizdown = "┳", horizup = "┻", msgsep = "‾", vert = "┃", verthoriz = "╋", vertleft = "┫", vertright = "┣" }, foldenable = false, foldlevel = 99, foldlevelstart = -1, hlsearch = true, ignorecase = true, inccommand = "split", laststatus = 3, list = true, mouse = "a", number = true, pumheight = 5, relativenumber = true, scrolloff = 10, shiftwidth = 4, showmode = false, signcolumn = "yes", smartcase = true, splitbelow = true, splitright = true, swapfile = false, synmaxcol = 100, tabstop = 4, termguicolors = true, timeoutlen = 400, title = true, undofile = true, updatetime = 250 }

  for k,v in pairs(nixvim_options) do
    vim.opt[k] = v
  end
end
-- }}}


require('lz.n').load( { { "catppuccin-nvim", after = function()
 require('catppuccin').setup({ custom_highlights = function(colors)
  return {
    Pmenu = { bg = colors.base, fg = colors.text },
    FloatBorder = { bg = colors.base, fg = colors.text },
    NormalFloat = { bg = colors.base },

    LspFloatWinNormal = { bg = colors.base },
    RenderMarkdownCode    = { bg = colors.base },
    LspInlayHint = {bg = colors.none },
    LspSignatureActiveParameter = { bg = colors.none, fg = colors.overlay0 },
  }
end
, no_italic = true })
 
end, colorscheme = "catppuccin" }, { "render-markdown.nvim", after = function()
 require('render-markdown').setup({ })
 
end, ft = "markdown" }, { "neorg", after = function()
 require('neorg').setup({ load = { ["core.completion"] = { config = { engine = { module_name = "external.lsp-completion" } } }, ["core.concealer"] = { config = { icon_preset = "diamond", icons = { code_block = { conceal = true, content_only = false, highlight = "CodeCell", min_width = 85, spell_check = false, width = "content" }, delimiter = { horizontal_line = { right = "textwidth" } }, heading = { icons = { "◆", "❖", "◈", "◇", "⟡", "⋄" } }, todo = { cancelled = { icon = "×" }, pending = { icon = "~" }, uncertain = { icon = "?" }, undone = { icon = " " }, urgent = { icon = "!" } } }, ordered_icons = {
  ["1"] = function(i)
    if i < 10 then
      return "0" .. i
    end
    return tostring(i)
  end;
};

 } }, ["core.defaults"] = { }, ["core.dirman"] = { config = { default_workspace = "notes", workspaces = { notes = "~/notes" } } }, ["core.esupports.metagen"] = { config = { type = "empty", undojoin_updates = true } }, ["core.export"] = { }, ["core.journal"] = { config = { journal_folder = "2_Live/journal", strategy = "flat", workspace = "notes" } }, ["core.keybinds"] = { config = { default_keybinds = true } }, ["core.tangle"] = { indent_errors = "print", report_on_empty = false }, ["external.interim-ls"] = { config = { completion_provider = { enable = true } } }, ["external.templates"] = { default_subcommand = "add", templates_dir = vim.fn.stdpath("config") .. "/templates/norg"; } } })
 
end, cmd = "Neorg", ft = "norg" }, { "indent-blankline.nvim", after = function()
 require('ibl').setup({ indent = { char = "╎" }, scope = { show_end = false, show_exact_scope = true, show_start = false } })
 
end, event = "DeferredUIEnter" }, { "image.nvim", after = function()
 require('image').setup({ backend = "kitty", editorOnlyRenderWhenFocused = true, integrations = { markdown = { onlyRenderImageAtCursor = true }, neorg = { filetypes = { "norg" }, onlyRenderImageAtCursor = true } }, maxHeight = 15, maxWidth = 100, windowOverlapClearEnabled = true, windowOverlapClearFtIgnore = { "cmp_menu", "cmp_docs", "fidget", "" } })
 
end, ft = { "norg", "md", "markdown", "png", "jpg", "webm" } }, { "fzf-lua", after = function()
 require('fzf-lua').setup({ files = { color_icons = true, file_icons = true, find_opts = [[-type f -not -path '*.git/objects*' -not -path '*.env*']], multiprocess = true, prompt = "Files: " }, winopts = { border = "rounded" } })
 
end, event = "DeferredUIEnter" }, { "conform.nvim", after = function()
 require('conform').setup({ format_on_save = function(bufnr)
  local disable_filetypes = { c = true, cpp = true }
  return {
    timeout_ms = 500,
    lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype]
  }
end
, formatters = { shfmt = { args = { "-i", "4", "-ci", "-kp" }, command = "shfmt" } }, formatters_by_ft = { c = { "clang-format" }, css = { "prettierd" }, dockerfile = { "prettierd" }, html = { "prettierd" }, javascript = { "prettierd" }, lua = { "stylua" }, markdown = { "prettierd" }, nix = { "alejandra" }, python = { "ruff", "black" }, sh = { "shfmt" }, xml = { "xmlformat" }, yaml = { "yamlfmt" } }, notify_on_error = false })
 
end, event = "BufWritePre" }, { "nvim-colorizer.lua", after = function()
 require('colorizer').setup({ user_default_options = { mode = "virtualtext", names = false, virtualtext = " ", virtualtext_inline = true } })
 
end, ft = { "ini", "css", "html", "toml", "js", "ts", "yaml" } } })

vim.diagnostic.config({ float = { border = "rounded" }, severity_sort = true, signs = { texthl = { [vim.diagnostic.severity.ERROR] = "DiagnosticError", [vim.diagnostic.severity.HINT] = "DiagnosticHint", [vim.diagnostic.severity.INFO] = "DiagnosticInfo", [vim.diagnostic.severity.WARN] = "DiagnosticWarn" } }, update_in_insert = true, virtual_text = false })

vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.breakindentopt = 'list:-1'
vim.opt.formatlistpat = '^\\s*[-~>]\\+\\s\\((.)\\s\\)\\?'

vim.loader.enable()

vim.api.nvim_create_user_command('DF', function()
  vim.fn.delete(vim.fn.expand('%:p'))
  vim.cmd('bd')
end, {})

function RenameCurrentFile()
  local old = vim.fn.expand("%")
  vim.ui.input({ prompt = "New name: ", default = old }, function(new)
    if not new or new == "" or new == old then
      return
    end
    vim.cmd("saveas " .. new)
    vim.cmd("silent !rm " .. old)
    vim.cmd("e " .. new)
  end)
end

vim.api.nvim_create_user_command("RF", function()
  RenameCurrentFile()
end, {})

local ls = require("luasnip")

require"img-clip".setup {
  default = {
    dir_path = "fig",
  },
}


vim.g.vimtex_fold_enabled = 1  -- включить складки в vimtex
vim.g.vimtex_fold_manual = 0   -- автоматически создавать складки
vim.g.vimtex_fold_types = {
  sections = {
    enabled = 1,  -- сворачивать \section, \subsection и т.д.
  },
  environments = {
    blacklist = {}, -- окружения, которые не надо сворачивать
    enabled = 1,    -- сворачивать \begin{...} \end{...}
  },
}

-- vim.api.nvim_create_autocmd("FileType", {
--     pattern = "*[0-9]*norg",
--     callback = function()
--         local stackoverflow = "~/Desktop/notes/2_Live/journal/stackoverflow.norg"
--         local original_win = vim.api.nvim_get_current_win()
--         local width = math.floor(vim.o.columns * 0.2)
--         vim.cmd("vsplit" .. stackoverflow)
--         vim.cmd("vertical resize " .. width)
--         vim.api.nvim_set_current_win(original_win)
--     end
-- })

-- vim.api.nvim_create_autocmd("BufLeave", {
--     pattern = "norg",
--     callback = function()
--         for _, win in ipairs(vim.api.nvim_list_wins()) do
--             local buf = vim.api.nvim_win_get_buf(win)
--             local bufname = vim.api.nvim_buf_get_name(buf)
--             if bufname:find("stackoverflow%.norg") then
--                 vim.api.nvim_win_close(win, true)
--             end
--         end
--     end,
-- })

-- https://www.reddit.com/r/neovim/comments/1dkgf49/comment/l9hzd08/
local function fzf_create_file()
	local fzf = require("fzf-lua")
	local path = require("fzf-lua.path")
	local uv = vim.uv or vim.loop
	local cmd = string.format("find %s -type d -not -path '*/\\.*'", uv.cwd())
	local function get_full_path(selected)
		if #selected < 1 then
			return
		end
		local entry = path.entry_to_file(selected[1], { cwd = uv.cwd() })
		if entry.path == "<none>" then
			return
		end
		-- Taken from require('fzf-lua').files, maybe there's a better way?
		local fullpath = entry.path or entry.uri and entry.uri:match("^%a+://(.*)")
		if not path.is_absolute(fullpath) then
			fullpath = path.join({ uv.cwd(), fullpath })
		end
		return fullpath
	end
	fzf.fzf_exec(cmd, {
		defaults = {},
		prompt = "> ",
		cwd = uv.cwd(),
		cwd_prompt_shorten_len = 32,
		cwd_prompt_shorten_val = 1,
		fzf_opts = {
			["--tiebreak"] = "end",
			["--preview"] = {
				type = "cmd",
				fn = function(selected)
					local fullpath = get_full_path(selected)
					return string.format("command ls -Alhv --group-directories-first %s", fullpath)
				end,
			},
		},
		fn_transform = function(x)
			return fzf.make_entry.file(x, { file_icons = true, color_icons = true, cwd = uv.cwd() })
		end,
		actions = {
			["default"] = function(selected)
				local fullpath = get_full_path(selected)
				-- If you have dressing.nvim, you can get "pretty" input dialog box
				vim.ui.input({ prompt = "File Name: " }, function(name)
					if name == nil then
						return
					end
					vim.cmd("e " .. fullpath .. "/" .. name)
					vim.cmd("w ++p") -- will create directory if not exists, so you can write new/dir/some_file.lua.
				end)
			end,
		},
	})
end

vim.keymap.set({ "n", "v", "i" }, "<C-x><C-f>", function()
	require("fzf-lua").complete_path()
end, { silent = true })

vim.keymap.set({ "i" }, "<C-x><C-f>", function()
	require("fzf-lua").complete_file({
		cmd = "rg --files",
		winopts = { preview = { hidden = true } },
	})
end, { silent = true })

vim.keymap.set({ "n" }, "<leader>fc", function()
	fzf_create_file()
end, { silent = true })

vim.keymap.set({ "n", "v", "i" }, "<C-ч><C-а>", function()
	require("fzf-lua").complete_path()
end, { silent = true })

vim.keymap.set({ "i" }, "<C-ч><C-а>", function()
	require("fzf-lua").complete_file({
		cmd = "rg --files",
		winopts = { preview = { hidden = true } },
	})
end, { silent = true })

vim.keymap.set({ "n" }, "<leader>ас", function()
	fzf_create_file()
end, { silent = true })


require("lz.n").load {
    {
        "vim-pencil",
        ft = {"tex", "md", "text"},
    },

 
    vim.api.nvim_create_user_command('ToggleDiagnostics', function()
      local loclist_exists = vim.fn.loclist(0) ~= ''
      if loclist_exists then
        vim.cmd('lclose')  -- Закрыть, если уже открыт
      else
        vim.diagnostic.setloclist()  -- Обновить и открыть, если закрыт
        vim.cmd('lopen')
      end
    end, {})
    

require("leap").opts.labels = {
	"s",
	"f",
	"n",
	"j",
	"k",
	"l",
	"h",
	"o",
	"d",
	"w",
	"e",
	"m",
	"b",
	"u",
	"y",
	"v",
	"r",
	"g",
	"t",
	"c",
	"x",
	"z",
	"S",
	"F",
	"N",
	"J",
	"K",
	"L",
	"H",
	"O",
	"D",
	"W",
	"E",
	"M",
	"B",
	"U",
	"Y",
	"V",
	"R",
	"G",
	"T",
	"C",
	"X",
	"Z",
}

require("leap").opts.safe_labels = {
	"s",
	"f",
	"n",
	"u",
	"t",
	"S",
	"F",
	"N",
	"L",
	"H",
	"M",
	"U",
	"G",
	"T",
	"Z",
}

require("leap").opts.highlight_unlabeled_phase_one_targets = true

require("leap").opts.substitute_chars = {
	["\r"] = "¬",
	[" "] = "·",
}

require("leap").opts.equivalence_classes = {
	" \n",
	")]}>",
	"([{<",
	{ '"', "'", "`" },
}

require("leap").opts.special_keys = {
	repeat_search = "",
	next_phase_one_target = "",
	next_target = { ";" },
	prev_target = { "," },
	next_group = "",
	prev_group = "",
	multi_accept = "",
	multi_revert = "",
}

-- Настройка цвета для LeapBackdrop
vim.api.nvim_set_hl(0, "LeapBackdrop", { fg = "#666666" })

vim.keymap.set({ 'n', 'x', 'o' }, "ы", "<Plug>(leap-forward)", { })
vim.keymap.set({'n', 'x', 'o'}, 'Ы',  '<Plug>(leap-backward)', { })

-- spooky

-- require("leap-spooky").setup({
-- 	extra_text_objects = nil,
-- 	affixes = {
-- 		magnetic = { window = "m" },
-- 		remote = { window = "r" },
-- 	},
-- 	prefix = false,
-- 	paste_on_remote_yank = false,
-- })

require("langmapper").automapping { global = true, buffer = true }

local function escape(str)
    local escape_chars = [[;,."|\]]
    return vim.fn.escape(str, escape_chars)
end

local en = [[`qwertyuiop[]asdfghjkl;'zxcvbnm]]
local ru = [[ёйцукенгшщзхъфывапролджэячсмить]]
local en_shift = [[~QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>]]
local ru_shift = [[ËЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ]]

vim.opt.langmap = vim.fn.join({
    escape(ru_shift) .. ';' .. escape(en_shift),
    escape(ru) .. ';' .. escape(en),
}, ',')


require("leap.util")["get-input"] = function()
    local ok, ch = pcall(vim.fn.getcharstr)
    if ok and ch ~= vim.api.nvim_replace_termcodes("<esc>", true, false, true) then
        return require("langmapper.utils").translate_keycode(ch, "default", "ru")
    end
end

-- Map
local map = require('langmapper').map

map("n", "<leader>.", "gcc", { remap = true })
map("v", "<leader>.", "gc", { remap = true })

map("i", "<C-р>", "<Left>", { })
map("i", "<C-д>", "<Right>", { })
map("i", "<C-о>", "<Down>", { })
map("i", "<C-л>", "<Up>", { })


vim.cmd([[colorscheme catppuccin
]])

require("mini.icons").setup({ enable = true })

require("mini.pairs").setup({ })

require("mini.statusline").setup({ })

require("mini.surround").setup({ mappings = { add = "gsa", delete = "gsd", find = "gsf", find_left = "gsF", highlight = "gsh", replace = "gsr", update_n_lines = "gsn" } })
MiniIcons.mock_nvim_web_devicons()

-- nvim-lspconfig {{{
do
  

  -- inlay hint
  vim.lsp.inlay_hint.enable(true)

  local __lspServers = { { name = "texlab" }, { extraOptions = { settings = { nixd = { diagnostic = { suppress = { "sema-escaping-with", "var-bind-to-this" } }, nixpkgs = { expr = "import (builtins.getFlake \"/nix/store/ggm7kigldixpcyy6jpc207h5hinrac6x-source\").inputs.nixpkgs { }" }, options = { ["home-manager"] = { expr = "(builtins.getFlake \"/nix/store/ggm7kigldixpcyy6jpc207h5hinrac6x-source\").nixosConfigurations.desktop.options.home-manager.users.type.getSubOptions [ ]" }, nixos = { expr = "(builtins.getFlake \"/nix/store/ggm7kigldixpcyy6jpc207h5hinrac6x-source\").nixosConfigurations.desktop.options" }, nixvim = { expr = "(builtins.getFlake \"/nix/store/ggm7kigldixpcyy6jpc207h5hinrac6x-source\").packages.${builtins.currentSystem}.nvim.options" } } } } }, name = "nixd" }, { name = "nginx_language_server" }, { name = "marksman" }, { extraOptions = { settings = { Lua = { completion = { callSnippet = "Replace" } } } }, name = "lua_ls" }, { extraOptions = { settings = { ltex = { additionalRules = { enablePickyRules = true, motherTongue = "ru-RU" }, completionEnabled = true, environments = { lstlisting = "ignore", minted = "ignore", verbatim = "ignore" }, language = "ru-RU", latex = { commands = { ["\\cite[]{}"] = "dummy", ["\\cite{}"] = "dummy", ["\\documentclass[]{}"] = "ignore", ["\\label{}"] = "ignore" } } } } }, name = "ltex" }, { name = "html" }, { name = "dockerls" }, { name = "cssls" }, { name = "clangd" }, { name = "bashls" }, { name = "basedpyright" } }
  -- Adding lspOnAttach function to nixvim module lua table so other plugins can hook into it.
  _M.lspOnAttach = function(client, bufnr)
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

require("lspconfig")["basedpyright"].setup({
	on_attach = on_attach,
	settings = {
		python = {
			analysis = {
				diagnosticSeverityOverrides = {
					reportUnusedExpression = "none",
				},
			},
		},
	},
})

  end
  local __lspCapabilities = function()
    capabilities = vim.lsp.protocol.make_client_capabilities()

    capabilities = vim.tbl_deep_extend("force", capabilities, require('cmp_nvim_lsp').default_capabilities())


    return capabilities
  end

  local __setup = {
            on_attach = _M.lspOnAttach,
            capabilities = __lspCapabilities(),
          }

  for i, server in ipairs(__lspServers) do
    local options = server.extraOptions

    if options == nil then
      options = __setup
    else
      options = vim.tbl_extend("keep", options, __setup)
    end

    require("lspconfig")[server.name].setup(options)
  end

  
end
-- }}}

local cmp = require('cmp')
cmp.setup({ completion = { completeopt = "menu,menuone,preview,noinsert" }, formatting = { format = function(entry, vim_item)
  local icons = {
    Class = " ",
    Color = " ",
    Constant = " ",
    Constructor = " ",
    Enum = " ",
    EnumMember = " ",
    Field = "󰄶 ",
    File = " ",
    Folder = " ",
    Function = "ƒ ",
    Interface = "󰜰 ",
    Keyword = "󰌆 ",
    Method = "󰡱 ",
    Module = "󰏗 ",
    Property = " ",
    Snippet = "󰘍 ",
    Struct = " ",
    Text = " ",
    Unit = " ",
    Value = "󰎠 ",
    Variable = "󰫧 ",
  }

  vim_item.kind = icons[vim_item.kind] or vim_item.kind
  return vim_item
end
 }, mapping = { ["<C-n>"] = cmp.mapping.select_next_item(), ["<C-p>"] = cmp.mapping.select_prev_item(), ["<CR>"] = cmp.mapping.confirm { select = true }, ["<Esc>"] = cmp.mapping(function(fallback)
  if cmp.visible() then
    cmp.abort()
    fallback()
  else
    fallback()
  end
end, {"i", "s"})
 }, sources = { { name = "luasnip" }, { name = "vimtex" }, { name = "nvim_lsp" }, { name = "path" }, { name = "buffer" } }, window = { completion = { border = "rounded" }, documentation = { border = "rounded" } } })

cmp.setup.cmdline(':', { mapping = {
  ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "c" }),
  ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "c" }),
  ["<Tab>"] = {
  c = function(default)
      if cmp.visible() then
        return cmp.confirm({ select = true })
      end
    default()
  end,},
}
, sources = { { name = "path" }, { name = "cmdline", option = { ignore_cmds = { "Man", "!" } } } } })

vim.opt.runtimepath:prepend(vim.fs.joinpath(vim.fn.stdpath('data'), 'site'))
require('nvim-treesitter.configs').setup({ highlight = { enable = true }, indent = { enable = true }, parser_install_dir = vim.fs.joinpath(vim.fn.stdpath('data'), 'site') })

require('luasnip').config.setup({ })


require('lsp_lines').setup()

require('leap').add_default_mappings()
require('leap').opts = vim.tbl_deep_extend(
  "keep",
  { },
  require('leap').opts
)

-- Set up keybinds {{{
do
  local __nixvim_binds = { { action = function() require('fzf-lua').blines() end, key = ".", mode = "n" }, { action = function() require('fzf-lua').blines() end, key = "/", mode = "n" }, { action = function() require('fzf-lua').diagnostics_document() end, key = "<leader>dd", mode = "n" }, { action = function() require('fzf-lua').buffers() end, key = "<leader>fb", mode = "n" }, { action = function() require('fzf-lua').files() end, key = "<leader>ff", mode = "n" }, { action = function() require('fzf-lua').git_status() end, key = "<leader>fg", mode = "n" }, { action = function() require('fzf-lua').oldfiles() end, key = "<leader>fo", mode = "n" }, { action = function() require('fzf-lua').live_grep() end, key = "<leader>fw", mode = "n" }, { action = function() require('fzf-lua').diagnostics_workspace() end, key = "<leader>wd", mode = "n" }, { action = function() require('fzf-lua').files() end, key = "<leader>аа", mode = "n" }, { action = function() require('fzf-lua').buffers() end, key = "<leader>аи", mode = "n" }, { action = function() require('fzf-lua').git_status() end, key = "<leader>ап", mode = "n" }, { action = function() require('fzf-lua').live_grep() end, key = "<leader>ац", mode = "n" }, { action = function() require('fzf-lua').oldfiles() end, key = "<leader>ащ", mode = "n" }, { action = function() require('fzf-lua').diagnostics_document() end, key = "<leader>вв", mode = "n" }, { action = function() require('fzf-lua').diagnostics_workspace() end, key = "<leader>цв", mode = "n" }, { action = "<Up>", key = "<C-k>", mode = "i" }, { action = "<Down>", key = "<C-j>", mode = "i" }, { action = "<Right>", key = "<C-l>", mode = "i" }, { action = "<Left>", key = "<C-h>", mode = "i" }, { action = "gc", key = "<leader>/", mode = "v", options = { remap = true } }, { action = "gcc", key = "<leader>/", mode = "n", options = { remap = true } }, { action = "P", key = "p", mode = "v", options = { silent = true } }, { action = "<C-r>", key = "U", mode = "n", options = { silent = true } }, { action = "<nop>", key = "q:", mode = "n", options = { noremap = true, silent = true } }, { action = "<nop>", key = "K", mode = "v", options = { noremap = true, silent = true } }, { action = "<cmd>nohlsearch<CR>", key = "<Esc>", mode = "n" }, { action = "<cmd>nohlsearch<CR>", key = "q", mode = "n" }, { action = "<nop>", key = "Q", mode = "n" }, { action = "<nop>", key = "й", mode = "n" }, { action = "<nop>", key = "Й", mode = "n" }, { action = "<nop>", key = "q", mode = "n" }, { action = "<nop>", key = "n", mode = "n" }, { action = "<nop>", key = "N", mode = "n" }, { action = "<C-w><C-h>", key = "<C-h>", mode = "n" }, { action = "<C-w><C-l>", key = "<C-l>", mode = "n" }, { action = "<C-w><C-j>", key = "<C-j>", mode = "n" }, { action = "<C-w><C-k>", key = "<C-k>", mode = "n" }, { action = "<nop>", key = "?", mode = "n" }, { action = "<cmd>PasteImage<cr>", key = "<leader>p", mode = "n" }, { action = "<C-w><C-k>", key = "<C-k>", mode = "n" }, { action = ":bd<CR>", key = "<localleader>q", mode = "n" }, { action = "<cmd>:lua require'luasnip'.jump(1)<CR>", key = "<A-l>", mode = "i", options = { silent = true } }, { action = "<cmd>:lua require'luasnip'.jump(-1)<CR>", key = "<A-h>", mode = "i", options = { silent = true } }, { action = function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end
, key = "<A-e>", mode = "i", options = { silent = true } }, { action = function() ls.jump(1) end, key = "<A-l>", mode = "n", options = { silent = true } }, { action = function() ls.jump(-1) end, key = "<A-h>", mode = "n", options = { silent = true } }, { action = ":UndotreeToggle<CR>:UndotreeFocus<CR>", key = "<leader>u", mode = "", options = { silent = true } }, { action = ":Neorg index<CR>", key = "<localleader>ii", mode = "n", options = { silent = true } }, { action = "<Plug>(neorg.qol.todo-items.todo.task-cycle)", key = "<localleader>;", mode = "n", options = { silent = true } }, { action = "<cmd>Neorg templates add journal<CR>", key = "<localleader>TT", mode = "n", options = { silent = true } }, { action = "<cmd>Neorg journal custom<CR>", key = "<localleader>jc", mode = "n", options = { silent = true } }, { action = "<Cmd>lua vim.diagnostic.goto_next()<CR>", key = "]d", mode = "n", options = { noremap = true, silent = true } }, { action = "<Cmd>lua vim.diagnostic.goto_prev()<CR>", key = "[d", mode = "n", options = { noremap = true, silent = true } } }
  for i, map in ipairs(__nixvim_binds) do
    vim.keymap.set(map.mode, map.key, map.action, map.options)
  end
end
-- }}}

require('mini.statusline').section_location = function()
              return '%2l:%-2v'
end

-- -- TODO: инвертировать bg при выделении и наоборот
-- vim.cmd [[
--   highlight MiniTablineCurrent gui=underline guisp=#b4befe guibg=#181825
--   highlight MiniTablineModifiedCurrent gui=underline guisp=#b4befe guibg=#181825 guifg=#f38ba8
--   highlight MiniTablineModifiedVisible guifg=#f38ba8 guibg=#181825
-- ]]

-- Set up autogroups {{
do
  local __nixvim_autogroups = { ["kickstart-highlight-yank"] = { clear = true }, nixvim_binds_LspAttach = { clear = true } }

  for group_name, options in pairs(__nixvim_autogroups) do
    vim.api.nvim_create_augroup(group_name, options)
  end
end
-- }}
-- Set up autocommands {{
do
  local __nixvim_autocommands = { { callback = function(args)
  do
    local __nixvim_binds = { { action = function() vim.lsp.buf.hover() end, key = "<A-k>", mode = "n", options = { noremap = true, silent = true } }, { action = "<Cmd>lua vim.lsp.buf.signature_help()<CR>", key = "<A-k>", mode = "i", options = { noremap = true, silent = true } } }

    for i, map in ipairs(__nixvim_binds) do
      local options = vim.tbl_extend("keep", map.options or {}, { buffer = args.buf })
      vim.keymap.set(map.mode, map.key, map.action, options)
    end
  end
end
, desc = "Load keymaps for LspAttach", event = "LspAttach", group = "nixvim_binds_LspAttach" }, { callback = function()
  vim.highlight.on_yank()
end
, event = { "TextYankPost" }, group = "kickstart-highlight-yank" }, { callback = function()
  require("lsp_lines").toggle()
  vim.o.winborder = "rounded"
end
, event = { "VimEnter" } }, { callback = function()
  local view = vim.fn.winsaveview()
  vim.cmd("normal! gg=G")
  vim.fn.winrestview(view)
end
, event = { "BufWritePost" }, pattern = "*.norg" } }

  for _, autocmd in ipairs(__nixvim_autocommands) do
        vim.api.nvim_create_autocmd(
      autocmd.event,
      {
        group     = autocmd.group,
        pattern   = autocmd.pattern,
        buffer    = autocmd.buffer,
        desc      = autocmd.desc,
        callback  = autocmd.callback,
        command   = autocmd.command,
        once      = autocmd.once,
        nested    = autocmd.nested
      }
    )
  end
end
-- }}

-- vim: ts=2 sts=2 sw=2 et


