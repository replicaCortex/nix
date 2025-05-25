{
  xsession.windowManager.bspwm = {
    enable = true;
    startupPrograms = [
      "pgrep -x sxhkd > /dev/null || sxhkd"
      "pgrep -x polybar > /dev/null || ~/nix/static/polybar/polybarStarup.sh"
      "pgrep -x clipmenud > /dev/null || clipmenud"
      "pgrep -x picom > /dev/null || picom --config ~/nix/static/picom/picom.conf"
      "pgrep -x feh > /dev/null || feh --bg-scale ~/nix/static/wallpapers/pixel-galaxy.png"
    ];

    extraConfig = ''
      xsetroot -cursor_name left_ptr
    '';

    monitors = {
      eDP-1 = [
        "I"
        "II"
        "III"
        "IV"
        "V"
      ];
    };

    settings = {
      border_width = 2;
      window_gap = 10;

      normal_border_color = "#313244";
      active_border_color = "#313244";
      focused_border_color = "#cba6f7";
      presel_feedback_color = "#cba6f7";
      pointer_follows_focus = true;
      # pointer_follows_monitor = true;

      split_ratio = 0.5;

      focus_follows_pointer = true;
      # pointer_modifier =  super;

      single_monocle = true;
      borderless_monocle = true;
      top_padding = 30;
    };
    rules = {
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

      # "zen" = {
      #   desktop = "^2";
      # };

      "qutebrowser" = {
        desktop = "^2";
      };

      "Zotero" = {
        desktop = "^4";
      };

      "qBittorrent" = {
        desktop = "^4";
      };
    };
  };
}
