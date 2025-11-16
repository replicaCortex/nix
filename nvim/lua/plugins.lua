return {
  {
    "nvim-treesitter/nvim-treesitter",
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    config = function()
      require "configs.treesitter"
    end,
  },

  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    config = function()
      require "configs.conform"
    end,
  },

  {
    "neovim/nvim-lspconfig",

    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "python", "markdown", "rust", "tex", "lua", "typst", "nix", "sh" },
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    dependencies = { "praczet/little-taskwarrior.nvim" },
    keys = {
      {
        "<leader>sH",
        function()
          require("snacks.picker").highlights()
        end,
        desc = "Highlights",
      },
      {
        "<leader>ff",
        function()
          require("snacks.picker").files()
        end,
      },
      {
        "<leader>fg",
        function()
          require("snacks.picker").grep()
        end,
      },
      {
        "<leader>fd",
        function()
          require("snacks.picker").diagnostics_buffer()
        end,
      },
      {
        "<leader>fu",
        function()
          require("snacks.picker").undo()
        end,
      },
      {
        "<C-n>",
        function()
          require("snacks.picker").explorer()
        end,
      },
      {
        "<leader>fo",
        function()
          require("snacks.picker").recent()
        end,
      },
      {
        "<leader>h",
        function()
          require("snacks.picker").help()
        end,
      },
      {
        "grr",
        function()
          require("snacks.picker").lsp_references()
        end,
      },
      {
        "<leader>fb",
        function()
          require("snacks.picker").buffers()
        end,
      },
      {
        "<leader>fs",
        function()
          require("snacks.picker").lsp_symbols()
        end,
      },
      {
        "<leader>fS",
        function()
          require("snacks.picker").lsp_workspace_symbols()
        end,
      },
      {
        "<leader>fn",
        function()
          require("snacks.picker").notifications()
        end,
      },
      {
        "<leader>fh",
        function()
          require("snacks.picker").command_history()
        end,
      },

      -- {
      --   "/",
      --   function()
      --     require("snacks.picker").lines {
      --       layout = {
      --         preview = "preview",
      --         preset = "dropdown",
      --       },
      --     }
      --   end,
      -- },
      -- {
      --   "?",
      --   function()
      --     require("snacks.picker").lines {
      --       layout = {
      --         preview = "preview",
      --         preset = "dropdown",
      --       },
      --     }
      --   end,
      -- },
      -- {
      --   ",",
      --   function()
      --     require("snacks.picker").lines {
      --       layout = {
      --         preview = "preview",
      --         preset = "dropdown",
      --       },
      --     }
      --   end,
      -- },
      -- {
      --   ".",
      --   function()
      --     require("snacks.picker").lines {
      --       layout = {
      --         preview = "preview",
      --         preset = "dropdown",
      --       },
      --     }
      --   end,
      -- },
    },
    opts = {
      picker = {
        sources = {
          explorer = {
            actions = {
              bufadd = function(_, item)
                if vim.fn.bufexists(item.file) == 0 then
                  local buf = vim.api.nvim_create_buf(true, false)
                  vim.api.nvim_buf_set_name(buf, item.file)
                  vim.api.nvim_buf_call(buf, vim.cmd.edit)
                end
              end,
              confirm_nofocus = function(picker, item)
                if item.dir then
                  picker:action "confirm"
                else
                  picker:action "bufadd"
                end
              end,
            },
            win = {
              list = {
                keys = {
                  ["l"] = "confirm_nofocus",
                  ["L"] = "confirm",
                },
              },
            },
            auto_close = true,
            layout = {
              cycle = true,
              preview = true,
              layout = {
                backdrop = false,
                row = 1,
                width = 0.4,
                min_width = 80,
                height = 0.8,
                border = "none",
                box = "vertical",
                { win = "preview", title = "{preview}", height = 0.4, border = true },
                {
                  box = "vertical",
                  border = true,
                  title = "{title} {live} {flags}",
                  title_pos = "center",
                  { win = "input", height = 1, border = "bottom" },
                  { win = "list", border = "none" },
                },
              },
            },
          },
        },
        layout = {
          preset = "dropdown",
        },
        win = {
          input = {
            keys = {
              ["<C-u>"] = { "<Esc>ddi", mode = { "i" }, expr = true },
            },
          },
        },
      },
      notifier = {},
      indent = {},
      bigfile = {},
      input = {},
      scope = {},
      dashboard = {
        formats = {
          header = { "%s", align = "center" },
          sections = { "%s", align = "center" },
        },
        width = 50,
        sections = function()
          local header = [[
            ___            
           /\  \           
          /  \/ \          
     ___  \   O /  ___     
    /    \ \   / /    \    
   /   __ -    -  __   \   
  /___/ | <>   <> | \___\  
  O  ___|    ^    |___  O  
   /     \   ~   /    \    
  /   /\  \_____/ /\   \   
  \_ / /          \ \_ /   
  O   /   /\   /\  \  O    
       \ /  \ /  \ /       
        O    O    O        
                ]]
          local function greeting()
            local hour = tonumber(vim.fn.strftime "%H")
            -- [02:00, 10:00) - morning, [10:00, 18:00) - day, [18:00, 02:00) - evening
            local part_id = math.floor((hour + 6) / 8) + 1
            local day_part = ({ "evening", "morning", "afternoon", "evening" })[part_id]
            local username = os.getenv "USER" or os.getenv "USERNAME" or "user"
            return ("Good %s, %s"):format(day_part, username)
          end

          local ltw = require "little-taskwarrior"

          return {
            { align = "center", text = { header, hl = "header" } },
            { align = "center", text = { greeting(), hl = "header" } },
            { padding = 1 },
            { icon = " ", key = "i", desc = "New File", action = ":ene | startinsert" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { padding = 1 },
            {
              title = "TaskWarrior",
              icon = "󰓥 ",
            },
            {
              text = ltw.get_snacks_dashboard_tasks(45, "dir", "special"),
              align = "center",
            },
            { padding = 1 },
            { section = "startup" },
          }
        end,
      },
    },
  },

  {
    "saghen/blink.cmp",
    version = "1.*",
    event = { "InsertEnter", "CmdLineEnter" },

    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        opts = { history = true, updateevents = "TextChanged" },
        config = function(_, opts)
          require("luasnip").config.set_config(opts)
          require "configs.snip"
        end,
      },
    },

    opts_extend = { "sources.default" },

    opts = function()
      return require "configs.blink"
    end,
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },

  -- {
  --   "Wansmer/langmapper.nvim",
  --   lazy = false,
  --   priority = 1,
  --
  --   config = function()
  --     require "configs.langmapper"
  --   end,
  -- },
  --
  --- UI ---

  {
    "nvchad/ui",
    dependencies = { "nvim-tree/nvim-web-devicons", "nvchad/base46" },
    config = function()
      require "nvchad"
      vim.api.nvim_set_hl(0, "@comment", { fg = "#4E4E4E", italic = true })
      vim.api.nvim_set_hl(0, "Comment", { fg = "#656565", italic = true })
      vim.api.nvim_set_hl(0, "LspInlayHint", { bg = "#282828", fg = "#656565" })
      vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = "#83A598", bold = true })
    end,
  },

  {
    "nvchad/base46",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = true,
    build = function()
      require("base46").load_all_highlights()
    end,
  },

  {
    "rachartier/tiny-glimmer.nvim",
    keys = { "y", "yy", "u", "r", "U", "R", "p", "P" },
    config = function()
      require("tiny-glimmer").setup {
        overwrite = {
          undo = {
            enabled = true,
            default_animation = {
              name = "fade",
              settings = {
                from_color = "#FB4934",
                max_duration = 500,
                min_duration = 500,
              },
            },
            undo_mapping = "u",
          },

          redo = {
            enabled = true,
            default_animation = {
              name = "fade",
              settings = {
                from_color = "#B8BB26",
                max_duration = 500,
                min_duration = 500,
              },
            },
            redo_mapping = "<c-r>",
          },

          paste = {
            enabled = true,
            default_animation = "fade",
            paste_mapping = "p",
            Paste_mapping = "P",
          },
        },

        animations = {
          fade = {
            from_color = "#FE8019",
            to_color = "#282828",
          },
        },
      }
    end,
  },

  --- other ---

  {
    "zk-org/zk-nvim",
    ft = { "markdown" },
    config = function()
      require("zk").setup {
        picker = "snacks_picker",
      }

      local opts = { noremap = true, silent = false }
      vim.api.nvim_set_keymap("n", "<leader>fz", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", opts)
      vim.api.nvim_set_keymap("n", "<leader>ft", "<Cmd>ZkTags<CR>", opts)
    end,
  },

  {
    "praczet/little-taskwarrior.nvim",
    config = function()
      require("little-taskwarrior").setup {
        dashboard = {
          limit = 10,
          project_replacements = {
            ["home."] = "h.",
            ["work."] = "w.",
          },
        },
      }
    end,
  },
}
