{
  programs.nixvim = {
    colorschemes.catppuccin = {
      enable = true;
      lazyLoad.enable = true;
    };
    plugins.lz-n = {
      enable = true;
    };
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
    # extraConfigLuaPre = ''
    #
    #   local image_setup_original = require("image").setup
    #   require("image").setup = function() end
    #
    #
    #   vim.api.nvim_create_autocmd("FileType", {
    #     pattern = { "markdown", "org" },
    #     callback = function()
    #       require("image").setup = image_setup_original
    #       require("image").setup({backend = "ueberzug",})
    #     end,
    #   })
    #
    #   vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    #     pattern = {"*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp"},
    #     callback = function()
    #       require("image").setup = image_setup_original
    #       require("image").setup()
    #     end
    #   })
    # '';
  };
}
