{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";

        monitor = 0;
        follow = "mouse";
        border = 1;
        indicate_hidden = "yes";
        shrink = "no";
        separator_height = 0;
        frame_width = 1;
        frame_color = "#89b4fa";
        sort = "no";
        font = "Ubuntu mono";
        line_height = 4;
        markup = "full";
        format = "<b>%s</b>\n%b";
        alignment = "left";
        word_wrap = "yes";
        ignore_newline = "no";
        stack_duplicates = false;
        hide_duplicate_count = "yes";
        show_indicators = "no";
        icon_position = "left";
        sticky_history = "yes";
        history_length = 20;
        # history = "ctrl + shift + alt + z";
        browser = "firefox";
        always_run_script = true;
        title = "Dunst";
        class = "Dunst";
      };
    };
  };
}
