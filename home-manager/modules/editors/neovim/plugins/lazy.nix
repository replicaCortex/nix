{
  programs.nixvim = {
    # colorschemes.catppuccin = {
    #   enable = true;
    #   lazyLoad.enable = true;
    # };
    # plugins.lz-n = {
    #   enable = true;
    # };
    # extraConfigLuaPre = ''
    #   -- Инициализация lz.n с настройкой для image.nvim
    #   require("lz.n").load({
    #     {
    #       "3rd/image.nvim", -- Имя плагина (как в вашем менеджере плагинов)
    #       ft = { "png", "jpg", "jpeg", "gif", "webp" }, -- Загрузка при открытии изображений
    #       -- Или используйте triggers:
    #       -- cmd  = "ImageView", -- Если плагин активируется командой
    #       -- keys = "<leader>img", -- Или по комбинации клавиш
    #       -- event = "FileType", -- Или по событию
    #
    #       -- Опционально: конфигурация плагина после загрузки
    #       after = function()
    #         require("image").setup({
    #           -- Ваши настройки image.nvim здесь
    #           render = {
    #             min_padding = 5,
    #             show_label = true,
    #           },
    #           events = {
    #             update_on_nvim_resize = true,
    #           },
    #         })
    #       end
    #     }
    #   })
    #
    # '';
    extraConfigLuaPre = ''

      local image_setup_original = require("image").setup
      require("image").setup = function() end


      -- vim.api.nvim_create_autocmd("FileType", {
      --   pattern = { "markdown", "org" },
      --   callback = function()
      --     require("image").setup = image_setup_original
      --     require("image").setup({backend = "ueberzug",})
      --   end,
      -- })

      vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
        pattern = {"*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.md", "*.norg", "*.ipynb"},
        callback = function()
          require("image").setup = image_setup_original
          require("image").setup({
            backend="ueberzug",
            integrations = {
              markdown = {
                enabled = true,
                -- clear_in_insert_mode = false,
                -- download_remote_images = false,
                -- only_render_image_at_cursor = true,
                filetypes = { "markdown", "quarto" }, -- markdown extensions (ie. quarto) can go here
              },
              neorg = {
                enabled = true,
                -- clear_in_insert_mode = false,
                -- download_remote_images = false,
                only_render_image_at_cursor = true,
                filetypes = { "norg" },
              },
            },
            -- max_width = 100,
            -- max_height = 8,
            max_height_window_percentage = math.huge,
            max_width_window_percentage = math.huge,
            -- window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
            editor_only_render_when_focused = true, -- auto show/hide images when the editor gains/looses focus
            tmux_show_only_in_active_window = true, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
            -- window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "fidget", ""},
          })
        end
      })
    '';
  };
}
