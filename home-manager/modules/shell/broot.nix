{pkgs, ...}: {
  programs.broot = {
    enable = true;
    settings = {
      verbs = [
        {
          invocation = "edit";
          shortcut = "ctrl-e";
          execution = "$EDITOR {file}";
        }
        {
          invocation = "view";
          execution = "less {file}";
        }
        {
          shortcut = "ctrl+j";
          execution = "down";
        }

        {
          shortcut = "ctrl+k";
          execution = "up";
        }

        {
          key = "ctrl-h";
          execution = ":parent";
        }

        {
          key = "ctrl-l";
          execution = ":focus";
        }

        {
          key = "ctrl-j";
          execution = ":line_down";
        }

        {
          key = "ctrl-k";
          execution = ":line_up";
        }

        {
          key = "ctrl-d";
          execution = ":page_down";
        }

        {
          key = "ctrl-u";
          execution = ":page_up";
        }
      ];
      icon_theme = "nerdfont";
    };
  };
}
