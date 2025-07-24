require("neorg").setup {
  load = {
    ["core.defaults"] = {},

    ["core.concealer"] = {
      config = {
        icon_preset = "diamond",
        ordered_icons = {
          ["1"] = function(i)
            return i < 10 and "0" .. i or tostring(i)
          end,
        },
        icons = {
          todo = {
            undone = { icon = " " },
            uncertain = { icon = "?" },
            urgent = { icon = "!" },
            pending = { icon = "~" },
            cancelled = { icon = "×" },
          },
          heading = {
            icons = { "◆", "❖", "◈", "◇", "⟡", "⋄" },
          },
          delimiter = {
            horizontal_line = { right = "textwidth" },
          },
          code_block = {
            conceal = true,
            spell_check = false,
            content_only = false,
            width = "content",
            min_width = 85,
            highlight = "CodeCell",
          },
        },
      },
    },

    -- ["external.templates"] = {
    --   config = {
    --     templates_dir = vim.fn.stdpath "config" .. "/templates/norg",
    --     default_subcommand = "add",
    --   },
    -- },

    ["core.qol.todo_items"] = {
      config = {},
    },

    -- ["core.keybinds"] = {
    --   config = {
    --     default_keybinds = true,
    --     neorg_leader = "<Leader>n",
    --   },
    -- },

    ["core.summary"] = {},

    ["core.tangle"] = {
      config = {
        indent_errors = "print",
        report_on_empty = false,
      },
    },

    ["core.dirman"] = {
      config = {
        workspaces = {
          note = "~/note",
        },
        default_workspace = "note",
      },
    },

    ["core.integrations.treesitter"] = {},
    -- ["core.export"] = {},
    ["core.journal"] = {
      config = {
        journal_folder = "journal",
        strategy = "flat",
        workspace = "note",
      },
    },

    ["core.completion"] = {
      config = { engine = { module_name = "external.lsp-completion" } },
    },

    -- ["core.esupports.metagen"] = {
    --   config = {
    --     undojoin_updates = true,
    --     type = "empty",
    --   },
    -- },

    ["external.interim-ls"] = {
      config = {
        completion_provider = { categories = true, people = { enable = true } },
      },
    },
  },
}

-- Keybindings
vim.api.nvim_set_keymap("n", "<localleader>ii", ":Neorg index<CR>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<localleader>;", "<Plug>(neorg.qol.todo-items.todo.task-cycle)", { silent = true })
vim.api.nvim_set_keymap("n", "<localleader>TT", "<cmd>Neorg templates add journal<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<localleader>jc", "<cmd>Neorg journal custom<CR>", { silent = true })

-- Autocommands
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.norg",
  callback = function()
    local view = vim.fn.winsaveview()
    vim.cmd "normal! gg=G"
    vim.fn.winrestview(view)
  end,
})
