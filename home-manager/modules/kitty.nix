{
  programs.kitty = {
    extraConfig = ''
      allow_remote_control yes
    '';
    enable = true;
    font = {
      name = "Cousine NerdFont";
      size = 12;
    };
    shellIntegration.enableZshIntegration = true;
    environment = {
      TERM = "kitty";
    };
    settings = {
      selection_save_to_clipboard = true;
      selection_semantic_escape_chars = ",│`|:\"' ()[]{}<>\t";

      color0 = "#23252e"; # black
      color1 = "#fd2e59"; # red
      color2 = "#5cc6d1"; # green
      color3 = "#ffc46b"; # yellow
      color4 = "#ff716a"; # blue
      color5 = "#cb75f7"; # magenta
      color6 = "#5cc6d1"; # cyan
      color7 = "#f9f8fe"; # white

      color8 = "#f9f8fe"; # bright black
      color9 = "#fd2e59"; # bright red
      color10 = "#5cc6d1"; # bright green
      color11 = "#ffc46b"; # bright yellow
      color12 = "#ff716a"; # bright blue
      color13 = "#cb75f7"; # bright magenta
      color14 = "#5cc6d1"; # bright cyan
      color15 = "#23252e"; # bright white

      cursor_shape = "beam";
      # cursor_underline_thickness = 4.0;
      # cursor = "#9e9e9e";
      # cursor_text_color = " #101010";
      # cursor_blink_interval = 0;
      confirm_os_window_close = 0;

      background = "#23252e";
      foreground = "#f9f7fe";
    };
  };
}
