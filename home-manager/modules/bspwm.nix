{
  xsession.windowManager.bspwm = {
    enable = true;
    startupPrograms = [
      "pgrep -x sxhkd > /dev/null || sxhkd"
      "pgrep -x polybar > /dev/null || polybar"
      #"picom"
      # "pgrep -x rofi > /dev/null || rofi"
      # "flameshot"
      "pgrep -x feh > /dev/null || feh --bg-scale ~/nix/home-manager/modules/conf/background/2.jpg"
      # "xsetroot -cursor_name left_ptr"
    ];

    monitors = {
      Virtual-1 = [
        ""
        ""
        "󰈹"
        ""
      ];
    };

    settings = {
      border_width = 1;
      window_gap = 10;

      normal_border_color = "#23252e";
      active_border_color = "#23252e";
      focused_border_color = "#f9f8fe";
      presel_feedback_color = "#23252e";

      split_ratio = 0.5;

      focus_follows_pointer = true;
      # pointer_modifier =  super;

      single_monocle = true;
      borderless_monocle = true;
    };
  };
}
