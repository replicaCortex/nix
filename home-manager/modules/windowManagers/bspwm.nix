{
  xsession.windowManager.bspwm = {
    enable = true;
    startupPrograms = [
      "pgrep -x sxhkd > /dev/null || sxhkd"
      "pgrep -x polybar > /dev/null || polybar"
      "pgrep -x clipmenud > /dev/null || clipmenud"
      # "pgrep -x flameshot > /dev/null || flameshot"
      # "pgrep -x alsa > /dev/null || alsa"
      # "pgrep -x redshift > /dev/null || redshift"
      # "pgrep -x polybar > /dev/null || ~/nix/home-manager/modules/conf/polybar/sh.sh"

      # "pgrep -x picom > /dev/null || picom"

      # "pgrep -x rofi > /dev/null || rofi"
      # "flameshot"
      "pgrep -x feh > /dev/null || feh --bg-scale ~/nix/static/wallpapers/nixos-wallpaper-catppuccin-mocha.png"
      # "xsetroot -cursor_name left_ptr"
    ];

    extraConfig = ''
      xsetroot -cursor_name left_ptr
    '';

    monitors = {
      HDMI-0 = [
        "I"
        "II"
        "III"
        "IV"
      ];
    };

    settings = {
      border_width = 1;
      window_gap = 10;

      normal_border_color = "#1e1e2e";
      active_border_color = "#1e1e2e";
      focused_border_color = "#89b4fa";
      presel_feedback_color = "#89b4fa";

      split_ratio = 0.5;

      focus_follows_pointer = true;
      # pointer_modifier =  super;

      single_monocle = true;
      borderless_monocle = true;
    };
    rules = {
      # "dmenu" = {
      #   rectangle = "900x22+610+90";
      # };
      "mpv" = {
        state = "floating";
        rectangle = "800x450+560+315";
        follow = false;
      };
      "PureRef" = {
        state = "floating";
        rectangle = "480x1080+0+0";
        desktop = "^3";
      };
      "krita" = {
        state = "floating";
        rectangle = "1440x1080+480+1080";
        desktop = "^3";
      };

      "firefox" = {
        desktop = "^2";
      };

      "zen" = {
        desktop = "^2";
      };

      "obs" = {
        desktop = "^4";
      };

      "Zotero" = {
        desktop = "^4";
      };

      # "Postman" = {
      #   state = "floating";
      #   rectangle = "565x425+1350+200";
      # };

      "qBittorrent" = {
        desktop = "^4";
      };

      # TODO: ВРЕМЕННЫЙ КАЛЕНДАРЬ
      "yad-calandar" = {
        # Position: 849,52 (screen: 0)
        # Geometry: 222x193

        state = "floating";
        rectangle = "200x100+850+200";
        follow = false;
      };

      "tabbed" = {
        state = "floating";
        rectangle = "620x450+1300+200";
        follow = false;
      };
    };
  };
}
