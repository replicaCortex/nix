{
  programs.alacritty = {
    enable = true;
    settings = {
      # colors = {
      #   bright = {
      #     black = "#f9f8fe";
      #     blue = "#ff716a";
      #     cyan = "#5cc6d1";
      #     green = "#5cc6d1";
      #     magenta = "#cb75f7";
      #     red = "#fd2e59";
      #     white = "#23252e";
      #     yellow = "#ffc46b";
      #   };
      #   cursor = {
      #     cursor = "CellForeground";
      #     text = "CellBackground";
      #   };
      #   normal = {
      #     black = "#23252e";
      #     blue = "#ff716a";
      #     cyan = "#5cc6d1";
      #     green = "#5cc6d1";
      #     magenta = "#cb75f7";
      #     red = "#fd2e59";
      #     white = "#f9f8fe";
      #     yellow = "#ffc46b";
      #   };
      #   primary = {
      #     background = "#23252e";
      #     foreground = "#f9f8fe";
      #   };
      # };

      # colors = {
      #   bright = {
      #     black = "#f9f8fe";
      #     blue = "#ff716a";
      #     cyan = "#5cc6d1";
      #     green = "#5cc6d1";
      #     magenta = "#cb75f7";
      #     red = "#fd2e59";
      #     white = "#23252e";
      #     yellow = "#ffc46b";
      #   };
      #   cursor = {
      #     cursor = "CellForeground";
      #     text = "CellBackground";
      #   };
      #   normal = {
      #     black = "#45475a";
      #     blue = "#f37799";
      #     cyan = "#74c7ec";
      #     green = "#74c7ec";
      #     magenta = "#f0addc";
      #     red = "#f38ba8";
      #     white = "#b4befe";
      #     yellow = "#f9e2af";
      #   };
      #   primary = {
      #     background = "#1e1e2e";
      #     foreground = "#b4befe";
      #   };
      # };

      colors = {
        primary = {
          background = "#1e1e2e";
          foreground = "#cdd6f4";
          dim_foreground = "#7f849c";
          bright_foreground = "#cdd6f4";
        };
        cursor = {
          text = "#1e1e2e";
          cursor = "#f5e0dc";
        };
        vi_mode_cursor = {
          text = "#1e1e2e";
          cursor = "#b4befe";
        };
        search = {
          matches = {
            foreground = "#1e1e2e";
            background = "#a6adc8";
          };
          focused_match = {
            foreground = "#1e1e2e";
            background = "#a6e3a1";
          };
        };
        footer_bar = {
          foreground = "#1e1e2e";
          background = "#a6adc8";
        };
        hints = {
          start = {
            foreground = "#1e1e2e";
            background = "#f9e2af";
          };
          end = {
            foreground = "#1e1e2e";
            background = "#a6adc8";
          };
        };
        selection = {
          text = "#1e1e2e";
          background = "#f5e0dc";
        };
        normal = {
          black = "#45475a";
          red = "#f38ba8";
          green = "#a6e3a1";
          yellow = "#f9e2af";
          blue = "#89b4fa";
          magenta = "#f5c2e7";
          cyan = "#89b4fa";
          white = "#bac2de";
        };
        bright = {
          black = "#585b70";
          red = "#f38ba8";
          green = "#a6e3a1";
          yellow = "#f9e2af";
          blue = "#89b4fa";
          magenta = "#f5c2e7";
          cyan = "#89b4fa";
          white = "#a6adc8";
        };
        indexed_colors = [
          {
            index = 16;
            color = "#fab387";
          }
          {
            index = 17;
            color = "#f5e0dc";
          }
        ];
      };

      font = {
        builtin_box_drawing = true;
        # size = 13.0;
        size = 12.0;
        # bold = {
        #   family = "Cousine NerdFont";
        #   style = "Bold";
        # };
        # normal = {
        #   family = "Cousine Nerd Font";
        #   style = "Regular";
        # };

        # bold = {
        #   family = "JetBrains Mono NerdFont";
        #   style = "Bold";
        # };
        # normal = {
        #   family = "JetBrains Mono Nerd Font";
        #   style = "Regular";
        # };

        # bold = {
        #   family = "BigBlueTerm437NerdFont";
        #   style = "Bold";
        # };
        # normal = {
        #   family = "BigBlueTerm437NerdFont";
        #   style = "Regular";
        # };

        # bold = {
        #   family = "ProggyClean NerdFont";
        #   style = "Bold";
        # };
        # normal = {
        #   family = "ProggyClean Nerd Font";
        #   style = "Regular";
        # };

        # bold = {
        #   family = "Departure Mono NerdFont";
        #   style = "Bold";
        # };
        # normal = {
        #   family = "Departure Mono Nerd Font";
        #   style = "Regular";
        # };

        bold = {
          family = "Ubuntu Mono";
          style = "Bold";
        };
        normal = {
          family = "Ubuntu Mono";
          style = "Regular";
        };

        # bold = {
        #   family = "GohuFont14 NerdFont";
        #   style = "Bold";
        # };
        # normal = {
        #   family = "GohuFont14 NerdFont";
        #
        #   # GohuFont14NerdFontMono
        #   style = "Regular";
        # };
      };

      scrolling = {
        history = 100;
      };

      window = {
        # padding = {
        #   x = 0;
        #   y = 0;
        # };
        dynamic_title = true;
        title = "Alacritty";
        class = {
          general = "Alacritty";
          instance = "Alacritty";
        };
      };

      env = {
        TERM = "xterm-256color";
      };

      selection = {
        save_to_clipboard = true;
        semantic_escape_chars = ",│`|:\"' ()[]{}<>\t";
      };
    };
  };
}
