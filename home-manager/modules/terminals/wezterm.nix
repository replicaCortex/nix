{
  programs.wezterm = {
    enable = true;

    extraConfig = ''
      local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
      local act = wezterm.action

      local config = {}

      config.color_scheme = "Catppuccin Mocha"
      config.enable_wayland = true

      config.term = "wezterm"

      config.font = wezterm.font("Ubuntu Mono")
      config.font_size = 10.0
      config.use_fancy_tab_bar = false
      config.tab_bar_at_bottom = false
      config.audible_bell = "Disabled"
      config.freetype_load_target = "Mono"

      config.window_decorations = "NONE"
      config.window_close_confirmation = "AlwaysPrompt"
      config.scrollback_lines = 3000
      -- config.default_workspace = "main"

      config.window_padding = {
      	left = 0,
      	right = 0,
      	top = 0,
      	bottom = 0,
      }

      config.inactive_pane_hsb = {
      	saturation = 0.80,
      	brightness = 0.80,
      }

      config.send_composed_key_when_left_alt_is_pressed = false
      config.send_composed_key_when_right_alt_is_pressed = false

      config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1000 }

      config.keys = {
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
      	{ key = "LeftArrow", mods = "CTRL|SHIFT", action = wezterm.action.DisableDefaultAssignment },
      	{ key = "RightArrow", mods = "CTRL|SHIFT", action = wezterm.action.DisableDefaultAssignment },
      	{ key = "UpArrow", mods = "CTRL|SHIFT", action = wezterm.action.DisableDefaultAssignment },
      	{ key = "DownArrow", mods = "CTRL|SHIFT", action = wezterm.action.DisableDefaultAssignment },
      	{ key = "k", mods = "CTRL|SHIFT", action = wezterm.action.DisableDefaultAssignment },
      	{ key = "PageUp", mods = "SHIFT", action = wezterm.action.DisableDefaultAssignment },
      	{ key = "PageDown", mods = "SHIFT", action = wezterm.action.DisableDefaultAssignment },

      	{ key = "\\", mods = "LEADER", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },

      	{ key = "-", mods = "LEADER", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },

      	{ key = "[", mods = "LEADER", action = act.ActivateCopyMode },
      	{ key = ":", mods = "LEADER", action = act.ActivateCommandPalette },
      	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
      	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
      	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
      	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },

      	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },

      	{ key = "r", mods = "LEADER", action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },
      	{ key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },

      	{ key = "w", mods = "LEADER", action = act.ShowTabNavigator },
      	{ key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },

      	{ key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
      	{
      		key = "!",
      		mods = "LEADER | SHIFT",
      		action = wezterm.action_callback(function(win, pane)
      			local tab, window = pane:move_to_new_tab()
      		end),
      	},
      	{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },

      	{ key = ".", mods = "LEADER", action = act.ActivateKeyTable({ name = "move_tab", one_shot = false }) },
      	{
      		key = ",",
      		mods = "LEADER",
      		action = act.PromptInputLine({
      			description = wezterm.format({
      				{ Attribute = { Intensity = "Bold" } },
      				{ Foreground = { AnsiColor = "Fuchsia" } },
      				{ Text = "Renaming Tab Title...:" },
      			}),
      			action = wezterm.action_callback(function(window, pane, line)
      				if line then
      					window:active_tab():set_title(line)
      				end
      			end),
      		}),
      	},
      }

      for i = 1, 9 do
      	table.insert(config.keys, {
      		key = tostring(i),
      		mods = "LEADER",
      		action = act.ActivateTab(i - 1),
      	})
      end

      config.key_tables = {
      	resize_pane = {
      		{ key = "<", action = act.AdjustPaneSize({ "Left", 1 }) },
      		{ key = "-", action = act.AdjustPaneSize({ "Down", 1 }) },
      		{ key = "+", action = act.AdjustPaneSize({ "Up", 1 }) },
      		{ key = ">", action = act.AdjustPaneSize({ "Right", 1 }) },
      		{ key = "Escape", action = "PopKeyTable" },
      		{ key = "Enter", action = "PopKeyTable" },
      	},
      	move_tab = {
      		{ key = "h", action = act.MoveTabRelative(-1) },
      		{ key = "j", action = act.MoveTabRelative(-1) },
      		{ key = "k", action = act.MoveTabRelative(1) },
      		{ key = "l", action = act.MoveTabRelative(1) },
      		{ key = "Escape", action = "PopKeyTable" },
      		{ key = "Enter", action = "PopKeyTable" },
      	},
      }
      return config
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
