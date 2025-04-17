{pkgs, ...}: let
  fuck = "$";
in {
  users.defaultUserShell = pkgs.zsh;

  environment.systemPackages = with pkgs; [
    zsh-powerlevel10k
    zsh-fzf-history-search
    # zsh-nix-shell
    zsh-fzf-tab
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = false;
    syntaxHighlighting.enable = true;
    shellAliases = {
      "na" = "bluetoothctl connect E4:61:F4:31:88:26";
      ".." = "cd ..";

      "hms" = "nh home switch --ask /home/replica/nix/ && dunstify '  NixOS' 'Home switch done 󰄬' || dunstify -u critical -h string:fgcolor:#f38ba8 '  NixOS' 'Home switch failed ❌' -t 4000";
      "nrs" = "nh os switch --ask /home/replica/nix/ && dunstify '  NixOS' 'Nix switch done 󰄬' || dunstify -u critical -h string:fgcolor:#f38ba8 '  NixOS' 'Home switch failed ❌' -t 4000";

      "nix clean" = "nh clean && dunstify '  NixOS' 'Clean done 󰄬' || dunstify -u critical -h string:fgcolor:#f38ba8 '  NixOS' 'Clean failed ❌' -t 4000";

      "nv" = "nvim .";
      "nb" = "nix build ./";
      "nd" = "nix develop ./";
      "nr" = "nix run";

      "jn" = "jupyter notebook";

      "cp" = "advcp -g";
      "mv" = "advmv -g";

      "gt" = "gcc -g -O0 -Wp,-U_FORTIFY_SOURCE";

      # "d" = "~/nix/static/sh/tmux.sh";

      "ext" = "~/nix/static/sh/ext.sh";

      "record" = "~/nix/static/sh/record.sh";

      "jc" = "cd ~/Desktop/notes/ && nvim ./index.norg";

      "en" = "euporie notebook";
      "ec" = "euporie console";
      "ep" = "euporie preview";

      # "ls" = "nnn -de";
      # "ls" = "br -dp";
    };

    shellInit = ''

      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
      source ${pkgs.zsh-fzf-history-search}/share/zsh-fzf-history-search/zsh-fzf-history-search.plugin.zsh
      # source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh

      setxkbmap -option grp:caps_toggle -layout us,ru
      bindkey -v

      # if [ -z "$TMUX" ] && [ -n "$DISPLAY" ]; then
      #   tmux attach-session -t default || tmux new-session -s default
      # fi

      # if [ -z "$TMUX" ] && [ -n "$DISPLAY" ]; then
      #   if ! tmux has-session -t default 2>/dev/null; then
      #     tmux new-session -s default
      #   fi
      #   # tmux attach-session -t default
      # fi

      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

      export EDITOR="nvim"
      export VISUAL="nvim"
      export TERMINAL="wezterm"
      export BROWSER="zen"

      export FZF_DEFAULT_OPTS="
        --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
        --color=fg:#cdd6f4,header:#f38ba8,info:#89b4fa,pointer:#f5e0dc
        --color=marker:#89b4fa,fg+:#cdd6f4,prompt:#89b4fa,hl+:#f38ba8
        --color=selected-bg:#45475a
        --color=border:#313244,label:#cdd6f4"
        # --layout=reverse"
      # --border-label="fzf!" --border-label-pos="0"


      # === nnn ===

      #-----
      export NNN_OPTS="re"
      export LC_COLLATE="C" # hidden files on top
      export NNN_FIFO="/tmp/nnn.fifo"
      export NNN_PREVIEW_FIFO="/tmp/nnn-preview-tui-fifo"
      export NNN_PLUG='p:preview-tabbed;f:fzopen;F:fzcd;d:dragdrop;x:!chmod +x "$nnn";y:xdgdefault'
      #-----

      # n ()
      # {
      #
      #     if [ -n $NNNLVL ] && [ "${fuck}{NNNLVL:-0}" -ge 1 ]; then
      #         echo "nnn is already running"
      #         return
      #     fi
      #     export NNN_TMPFILE="${fuck}{XDG_CONFIG_HOME:-${fuck}HOME/.config}/nnn/.lastd"
      #     nnn "$@"
      #     if [ -f "$NNN_TMPFILE" ]; then
      #             . "$NNN_TMPFILE"
      #             rm -f "$NNN_TMPFILE" > /dev/null
      #     fi
      #
      #     # rm -f "$NNN_FIFO" "$NNN_PREVIEW_FIFO"
      # }


      # # === yazi ===
      #
      # function y() {
      #   local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
      #   yazi "$@" --cwd-file="$tmp"
      #   if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
      #     builtin cd -- "$cwd"
      #   fi
      #   rm -f -- "$tmp"
      # }

    '';
  };
}
