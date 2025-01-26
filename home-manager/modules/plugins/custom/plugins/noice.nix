{
  programs.nixvim = {
    plugins.noice = {
      enable = true;
    };

    extraConfigLuaPre = ''

      local noice = require "noice"

      noice.setup {
        cmdline = {
          enabled = true, -- Включает UI командной строки Noice
          view = "cmdline_popup", -- Используется всплывающее окно для командной строки
          opts = {}, -- Глобальные опции для командной строки
          format = {
            cmdline = { pattern = "^:", icon = "󰥻 ", lang = "vim" },
            filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
            lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
            help = { pattern = "^:%s*he?l?p?%s+", icon = "󰋖 " },
            input = { view = "cmdline_input", icon = "󰿟 " }, -- Используется для input()
          },
        },
        redirect = {
          view = "popup", -- Редирект сообщений в попап
          filter = { event = "msg_show" },
        },
        commands = {
          history = {
            view = "split", -- Представление истории сообщений
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
            view = "popup", -- Последнее сообщение в попап
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
            view = "popup", -- Ошибки в попап
            opts = { enter = true, format = "details" },
            filter = { error = true },
            filter_opts = { reverse = true },
          },
          all = {
            view = "split", -- Все сообщения в split
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
            size = { width = 33, height = "auto" },
          },
          popupmenu = {
            relative = "editor",
            position = { row = 8, col = "50%" },
            size = { width = 40, height = 10 },
            border = { style = "rounded", padding = { 0, 1 } },
            win_options = { winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" } },
          },
        },
        routes = {},
        status = {},
        format = {},
      }

    '';
    keymaps = [
      {
        key = "<leader>fn";
        action = "<cmd>NoiceTelescope<CR>";
        options = {
          silent = true;
        };
      }
    ];
  };
}
