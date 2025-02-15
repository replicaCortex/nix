{
  programs.ranger = {
    enable = true;
    settings = {
      preview_images = true;
      preview_images_method = "iterm2";
      # preview_images_method = "kitty";
    };

    extraConfig = ''
      # ===================================================================
      # This file contains the default startup commands for ranger.
      # To change them, it is recommended to create either /etc/ranger/rc.conf
      # (system-wide) or ~/.config/ranger/rc.conf (per user) and add your custom
      # commands there.
      #
      # If you copy this whole file there, you may want to set the environment
      # variable RANGER_LOAD_DEFAULT_RC to FALSE to avoid loading it twice.
      #
      # The purpose of this file is mainly to define keybindings and settings.
      # For running more complex python code, please create a plugin in "plugins/" or
      # a command in "commands.py".
      #
      # Each line is a command that will be run before the user interface
      # is initialized.  As a result, you can not use commands which rely
      # on the UI such as :delete or :mark.
      # ===================================================================

      # ===================================================================
      # == Options
      # ===================================================================

      # Show hidden files? You can toggle this by typing 'zh'
      set show_hidden true

      # Be aware of version control systems and display information.
      set vcs_aware true

      # Which colorscheme to use?  These colorschemes are available by default:
      # default, jungle, snow, solarized
      # set colorscheme snow
      # set colorscheme custom

      # Draw borders around columns? (separators, outline, both, or none)
      # Separators are vertical lines between columns.
      # Outline draws a box around all the columns.
      # Both combines the two.
      set draw_borders outline

      # Display the directory name in tabs?
      set dirname_in_tabs true

      # Set the tmux/screen window-name to "ranger"?
      set update_tmux_title true

      # Show hostname in titlebar?
      set hostname_in_titlebar true

      # Abbreviate $HOME with ~ in the titlebar (first line) of ranger?
      set tilde_in_titlebar true

      # Changes case sensitivity for the cd command tab completion
      set cd_tab_case insensitive

      # Use fuzzy tab completion with the "cd" command. For example,
      # ":cd /u/lo/b<tab>" expands to ":cd /usr/local/bin".
      set cd_tab_fuzzy true

      # Avoid previewing files larger than this size, in bytes.  Use a value of 0 to
      # disable this feature.
      set preview_max_size 0

      # The key hint lists up to this size have their sublists expanded.
      # Otherwise the submaps are replaced with "...".
      set hint_collapse_threshold 10

      # Add the highlighted file to the path in the titlebar
      set show_selection_in_titlebar true

      # The delay that ranger idly waits for user input, in milliseconds, with a
      # resolution of 100ms.  Lower delay reduces lag between directory updates but
      # increases CPU load.
      set idle_delay 1500

      # Disable displaying line numbers in main column.
      # Possible values: false, absolute, relative.
      set line_numbers relative

      # Save tabs on exit
      # set save_tabs_on_exit true

      # Enable scroll wrapping - moving down while on the last item will wrap around to
      # the top and vice versa.
      set wrap_scroll true

      default_linemode devicons

      # set tmux_cwd_sync true
      # set tmux_set_title true
      # set tmux_open_in_window true
    '';
    #  TODO: разобраться как установить через nix

    # plugins = [
    #   {
    #     name = "ranger_tmux ";
    #     src = builtins.fetchGit {
    #       url = "https://github.com/joouha/ranger_tmux";
    #       rev = "05ba5ddf2ce5659a90aa0ada70eb1078470d972a";
    #       # tag = "v1.0.8";
    #     };
    #   }
    # ];
  };
}
