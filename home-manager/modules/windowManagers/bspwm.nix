{
  xsession.windowManager.bspwm = {
    enable = true;
    startupPrograms = [
      "pgrep -x sxhkd > /dev/null || sxhkd"
      "pgrep -x polybar > /dev/null || polybar"
      "pgrep -x clipmenud > /dev/null || clipmenud"
      "pgrep -x flameshot > /dev/null || flameshot"
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
      eDP-1 = [
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
    # rules = {
    #   "firefox" = {
    #     desktop = "^3";
    #   };
    # };
  };
}
