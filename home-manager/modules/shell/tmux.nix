{
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    # terminal = "screen-256color";
    # terminal = "tmux-256color";
    # terminal = "xterm-256color";
    terminal = "alacritty";
    # terminal = "xterm-kitty";
    # terminal = "rxvt-unicode-256color";

    extraConfig = ''

      # Plugin Manager
      # set -g @plugin 'tmux-plugins/tpm'

      # Theme/color stuff
      # set -s default-terminal 'tmux-256color'
      # set-option -ga terminal-overrides ",xterm-256color:Tc"
      # set -s default-terminal "xterm-kitty"
      # set -g @plugin 'jimeh/tmux-themepack'
      # set -g @themepack 'powerline/default/gray'

      # set -g default-terminal "tmux-256color"
      # set -ga terminal-overrides ",alacritty:Tc"

      # If if ever need escape in a tmux command maybe up this a little. But it makes nvim feel slow
      set escape-time 1 # in ms

      # ===REBINDS===
      # set prefix to ctrl space. Not sure that I'll like this, but it seems
      # like it might work out.. I'm wondering if I would have used that elsewhere,
      # but it seems like this is a good place to use such an easy key to hit, right?
      unbind C-Space
      set -g prefix C-Space
      bind C-Space send-prefix

      # open the terminal contents in nvim
      bind y send-keys "tmux capture-pane -p -S - | nvim -c 'set buftype=nofile' +" Enter

      # press y to copy from copy mode. leader + [ move around with vim keys,
      # v or space for visual select, V for visual line
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xclip -i -sel clip > /dev/null"
      bind-key -T copy-mode-vi v send-keys " "
      bind-key p run "xclip -o -sel clip | tmux load-buffer - ; tmux paste-buffer"

      bind Space select-window -t :0

      # rebind splits to be easier to remember
      bind | split-window -hc "#{pane_current_path}" # btw, | is sym + c on the cantor
      bind - split-window -vc "#{pane_current_path}"

      bind r source-file ~/.config/tmux/tmux.conf

      # rebind swapping window around, this makes intuitive sense.
      bind -r "<" swap-window -d -t -1
      bind -r ">" swap-window -d -t +1

      # resizing panes  with prefix Ctrl + h/j/k/l
      # so now you can hold ctrl + space and then hit the hjkl keys to resize
      bind -r C-j resize-pane -D 1
      bind -r C-k resize-pane -U 1
      bind -r C-h resize-pane -L 1
      bind -r C-l resize-pane -R 1

      # moving around with prefix hjkl
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # next tab with prefix t (this is just way more comfortable for me to type)
      bind t next-window

      # OTHER OPTIONS
      set -g mouse on # mouse support
      set -g history-limit 20000 # default was 2000
      # new window is c by the way
      bind c new-window -c "#{pane_current_path}" # keep path when creating a new window

      # this line is different on different machines... replace $TERM on the line below with $TERM
      # outside of tmux
      # set-option -sa terminal-overrides ',$TERM:RGB'
      set -sa terminal-overrides ',xterm-256color:Tc'
      set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
      set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colors

      set -g allow-passthrough on
      set -g visual-activity off # for image-nvim to work

      set -g focus-events on

      source "~/nix/static/tmux/bar.conf"

      # # Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
      # run '~/.tmux/plugins/tpm/tpm'


    '';
  };
}
