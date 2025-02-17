{
  programs.nixvim = {
    plugins.leap = {
      enable = true;
    };

    extraConfigLuaPre = ''

      require("leap").opts.highlight_unlabeled_phase_one_targets = true

      -- Настройка цветов с использованием highlight groups
      vim.api.nvim_set_hl(0, "LeapBackdrop", { fg = "#666666" })           -- Цвет для затемнённого текста
      -- vim.api.nvim_set_hl(0, "LeapMatch", { fg = "#9EFD38", bold = true }) -- Цвет совпадений

      -- Остальный настройки
      require("leap").opts.substitute_chars = { [" "] = "·" } -- Замена пробела на точку

    '';
  };
}
