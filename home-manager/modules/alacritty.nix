{
  programs.alacritty = {
    enable = true;
    settings = {
      colors = {
        bright = {
          black = "#f9f8fe";
          blue = "#ff716a";
          cyan = "#5cc6d1";
          green = "#5cc6d1";
          magenta = "#cb75f7";
          red = "#fd2e59";
          white = "#23252e";
          yellow = "#ffc46b";
        };
        cursor = {
          cursor = "CellForeground";
          text = "CellBackground";
        };
        normal = {
          black = "#23252e";
          blue = "#ff716a";
          cyan = "#5cc6d1";
          green = "#5cc6d1";
          magenta = "#cb75f7";
          red = "#fd2e59";
          white = "#f9f8fe";
          yellow = "#ffc46b";
        };
        primary = {
          background = "#23252e";
          foreground = "#f9f8fe";
        };
      };

      font = {
        builtin_box_drawing = true;
        size = 12.0;
        bold = {
          family = "Cousine NerdFont";
          style = "Bold";
        };
        normal = {
          family = "Cousine Nerd Font";
          style = "Regular";
        };
      };

      scrolling = {
        history = 100;
      };

      window = {
        padding = {
          x = 15;
          y = 15;
        };
        dynamic_title = true;
        title = "Alacritty";
        class = {
          general = "Alacritty";
          instance = "Alacritty";
        };
      };

      env = {
        TERM = "alacritty";
      };

      selection = {
        save_to_clipboard = true;
        semantic_escape_chars = ",│`|:\"' ()[]{}<>\t";
      };
    };
  };
}
