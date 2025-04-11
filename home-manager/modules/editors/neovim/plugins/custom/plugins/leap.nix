{
  programs.nixvim = {
    plugins.leap = {
      enable = true;
      labels = [
        "s"
        "f"
        "n"
        "j"
        "k"
        "l"
        "h"
        "o"
        "d"
        "w"
        "e"
        "m"
        "b"
        "u"
        "y"
        "v"
        "r"
        "g"
        "t"
        "c"
        "x"
        "z"
        "S"
        "F"
        "N"
        "J"
        "K"
        "L"
        "H"
        "O"
        "D"
        "W"
        "E"
        "M"
        "B"
        "U"
        "Y"
        "V"
        "R"
        "G"
        "T"
        "C"
        "X"
        "Z"
      ];

      highlightUnlabeledPhaseOneTargets = true;
      substituteChars = {
        "\r" = "¬";
        " " = "·";
      };
      equivalenceClasses = [
        ''

        ''
        ")]}>"
        "([{<"
        [
          "\""
          "'"
          "`"
        ]
      ];
    };

    extraConfigLuaPre = ''

      -- require("leap").setup({
      --   highlight_unlabeled_phase_one_targets = true,
      --   substitute_chars = { [" "] = "" },
      --   safe_labels = {},
      -- })

      -- Настройка цветов с использованием highlight groups
      vim.api.nvim_set_hl(0, "LeapBackdrop", { fg = "#666666" })           -- Цвет для затемнённого текста
      -- vim.api.nvim_set_hl(0, "LeapMatch", { fg = "#9EFD38", bold = true }) -- Цвет совпадений

      -- -- Переменная для отслеживания состояния Leap
      -- vim.g.leap_active = false
      --
      -- -- Устанавливаем флаг при входе в Leap
      -- vim.api.nvim_create_autocmd('User', {
      --   pattern = 'LeapEnter',
      --   callback = function()
      --     vim.g.leap_active = true
      --   end,
      -- })
      --
      -- -- Сбрасываем флаг при выходе из Leap
      -- vim.api.nvim_create_autocmd('User', {
      --   pattern = 'LeapLeave',
      --   callback = function()
      --     vim.g.leap_active = false
      --   end,
      -- })
    '';
  };
}
