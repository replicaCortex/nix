{
  programs.kitty = {
    extraConfig = ''
      allow_remote_control yes
    '';
    enable = true;
    font = {
      name = "Ubuntu Mono";
      size = 12;
      package = null;
    };
    shellIntegration.enableZshIntegration = true;
    environment = {
      TERM = "kitty";
    };
    settings = {
      background = "#1e1e2e";
      foreground = "#cdd6f4";
      selection_background = "#f5e0dc";
      selection_foreground = "#1e1e2e";
      cursor = "#f5e0dc";
      cursor_text_color = "#1e1e2e";

      # ANSI colors
      color0 = "#45475a";
      color1 = "#f38ba8";
      color2 = "#a6e3a1";
      color3 = "#f9e2af";
      color4 = "#89b4fa";
      color5 = "#f5c2e7";
      color6 = "#89b4fa";
      color7 = "#bac2de";

      # Bright ANSI colors
      color8 = "#585b70";
      color9 = "#f38ba8";
      color10 = "#a6e3a1";
      color11 = "#f9e2af";
      color12 = "#89b4fa";
      color13 = "#f5c2e7";
      color14 = "#89b4fa";
      color15 = "#a6adc8";

      # Extended colors
      color16 = "#fab387";
      color17 = "#f5e0dc";

      # Cursor & selection
      cursor_shape = "beam";
      confirm_os_window_close = 0;

      # Selection behavior
      selection_save_to_clipboard = true;
      selection_semantic_escape_chars = ",│`|:\"' ()[]{}<>\t";

      # Title
      dynamic_title = true;
      window_title = "Kitty";
    };
  };
}
