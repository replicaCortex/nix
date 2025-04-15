{
  programs.wezterm = {
    enable = true;

    extraConfig = ''
      return {
      	font = wezterm.font("Ubuntu Mono"),
      	font_size = 12.0,
      	color_scheme = "myCoolTheme",
      	hide_tab_bar_if_only_one_tab = true,
      	use_fancy_tab_bar = false,
      	enable_tab_bar = false,
      	audible_bell = "Disabled",
      	freetype_load_target = "Mono",
      	window_padding = {
      		left = 0,
      		right = 0,
      		top = 0,
      		bottom = 0,
      	},

      	send_composed_key_when_left_alt_is_pressed = false,
      	send_composed_key_when_right_alt_is_pressed = false,

      	keys = {
      		{ key = "+", mods = "CTRL", action = wezterm.action.DisableDefaultAssignment },
      		{ key = "+", mods = "SHIFT|CTRL", action = wezterm.action.DisableDefaultAssignment },
      		{ key = "-", mods = "CTRL", action = wezterm.action.DisableDefaultAssignment },
      		{ key = "-", mods = "SHIFT|CTRL", action = wezterm.action.DisableDefaultAssignment },
      		{ key = "-", mods = "SUPER", action = wezterm.action.DisableDefaultAssignment },
      		{ key = "=", mods = "CTRL", action = wezterm.action.DisableDefaultAssignment },
      		{ key = "=", mods = "SHIFT|CTRL", action = wezterm.action.DisableDefaultAssignment },
      		{ key = "=", mods = "SUPER", action = wezterm.action.DisableDefaultAssignment },
      		{ key = "_", mods = "CTRL", action = wezterm.action.DisableDefaultAssignment },
      		{ key = "_", mods = "SHIFT|CTRL", action = wezterm.action.DisableDefaultAssignment },
      		{ key = "w", mods = "SUPER", action = wezterm.action.DisableDefaultAssignment },
      		{ key = "w", mods = "SUPER|SHIFT", action = wezterm.action.DisableDefaultAssignment },
      		{ key = "m", mods = "SUPER", action = wezterm.action.DisableDefaultAssignment },
      	},
      }
    '';

    colorSchemes = {
      myCoolTheme = {
        ansi = [
          "#45475a"
          "#f38ba8"
          "#a6e3a1"
          "#f9e2af"
          "#89b4fa"
          "#f5c2e7"
          "#89b4fa"
          "#bac2de"
        ];
        brights = [
          "#585b70"
          "#f38ba8"
          "#a6e3a1"
          "#f9e2af"
          "#89b4fa"
          "#f5c2e7"
          "#89b4fa"
          "#a6adc8"
        ];
        background = "#1e1e2e";
        cursor_bg = "#f5e0dc";
        cursor_border = "#f5e0dc";
        cursor_fg = "#1e1e2e";
        foreground = "#cdd6f4";
        selection_bg = "#f5e0dc";
        selection_fg = "#1e1e2e";
      };
    };
  };
}
