{...}: let
  workspace1 = "workspace number 1";
  workspace2 = "workspace number 2";
  workspace3 = "workspace number 3";
  workspace4 = "workspace number 4";
  workspace5 = "workspace number 5";
  workspace6 = "workspace number 6";
  workspace7 = "workspace number 7";
  workspace8 = "workspace number 8";
  workspace9 = "workspace number 9";
  workspace10 = "workspace number 10";
in {
  wayland.windowManager.sway = {
    enable = true;
    xwayland = true;
    systemd.enable = true;

    # startup = [
    #   # {
    #   #   command = "pgrep -x feh > /dev/null || feh --bg-scale ~/nix/static/wallpapers/nixos-wallpaper-catppuccin-mocha.png";
    #   #   always = true;
    #   # }
    # ];

    extraConfig = ''
      seat * xcursor_theme default 24

      # for_window rules
      for_window [app_id="mpv"]       floating enable, resize set 800 450, move position 560 315
      for_window [app_id="PureRef"]   floating enable, move to workspace 3, resize set 480 1080, move position 0 0
      for_window [app_id="krita"]     floating enable, move to workspace 3, resize set 1440 1080, move position 480 1080
      for_window [app_id="firefox"]   move to workspace 2
      for_window [app_id="zen"]       move to workspace 2
      for_window [app_id="qutebrowser"] move to workspace 2
      for_window [app_id="Zotero"]    move to workspace 4
      for_window [app_id="qBittorrent"] move to workspace 4
    '';

    config = {
      terminal = "wezterm";
      seat.HDMI-0.hide_cursor = "10000";

      floating = {
        criteria = [
          {window_role = "pop-up";}
          {app_id = "mpv";}
        ];
      };

      input = {
        "type:keyboard" = {
          xkb_layout = "us,ru";
          xkb_options = "grp:caps_toggle";
          xkb_numlock = "false";
          repeat_delay = "250";
          repeat_rate = "25";
        };
      };

      keybindings = let
        syper_ctrl = "Mod4+ctrl";
        syper_shift = "Mod4+shift";
        syper = "Mod4";
        term = "wezterm";
      in {
        "${syper}+Return" = "exec ${term}";

        "shift + ctrl + z" = "exec wl-clipboard-manager lock";

        # Kill focused syper_ctrldow
        "${syper}+c" = "kill";

        # Change focus
        "${syper}+h" = "focus left";
        "${syper}+j" = "focus down";
        "${syper}+k" = "focus up";
        "${syper}+l" = "focus right";

        # Move focused syper_ctrldow
        "${syper_ctrl}+h" = "move left";
        "${syper_ctrl}+j" = "move down";
        "${syper_ctrl}+k" = "move up";
        "${syper_ctrl}+l" = "move right";

        # Enter fullscreen mode
        "${syper}+i" = "fullscreen";

        # Toggle tiling / floating
        "${syper}+o" = "floating toggle";

        # Split
        "${syper}+s" = "split toggle";

        # Reload the configuration file
        "${syper_ctrl}+r" = "reload";

        # Switch to workspace using number row
        "${syper}+1" = "${workspace1}";
        "${syper}+2" = "${workspace2}";
        "${syper}+3" = "${workspace3}";
        "${syper}+4" = "${workspace4}";
        "${syper}+5" = "${workspace5}";
        "${syper}+6" = "${workspace6}";
        "${syper}+7" = "${workspace7}";
        "${syper}+8" = "${workspace8}";
        "${syper}+9" = "${workspace9}";
        "${syper}+0" = "${workspace10}";

        # Move syper_ctrldow to workspace using number row
        "${syper_shift}+1" = "move container to ${workspace1}";
        "${syper_shift}+2" = "move container to ${workspace2}";
        "${syper_shift}+3" = "move container to ${workspace3}";
        "${syper_shift}+4" = "move container to ${workspace4}";
        "${syper_shift}+5" = "move container to ${workspace5}";
        "${syper_shift}+6" = "move container to ${workspace6}";
        "${syper_shift}+7" = "move container to ${workspace7}";
        "${syper_shift}+8" = "move container to ${workspace8}";
        "${syper_shift}+9" = "move container to ${workspace9}";
        "${syper_shift}+0" = "move container to ${workspace10}";
      };
    };
  };
}
