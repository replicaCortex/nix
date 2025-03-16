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
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      "na" = "bluetoothctl connect E4:61:F4:31:88:26";
      ".." = "cd ..";

      "hms" = "nh home switch --ask /home/replica/nix/ && dunstify '  NixOS' 'Home switch done 󰄬' || dunstify -u critical -h string:fgcolor:#f38ba8 '  NixOS' 'Home switch failed ❌' -t 4000";
      "nrs" = "nh os switch --ask /home/replica/nix/ && dunstify '  NixOS' 'Nix switch done 󰄬' || dunstify -u critical -h string:fgcolor:#f38ba8 '  NixOS' 'Home switch failed ❌' -t 4000";

      "nix clean" = "nh clean && dunstify '  NixOS' 'Clean done 󰄬' || dunstify -u critical -h string:fgcolor:#f38ba8 '  NixOS' 'Clean failed ❌' -t 4000";

      "systemState" = "ls -l /nix/var/nix/gcroots/auto";

      "nv" = "nvim .";
      "nb" = "nix build ./";
      "nd" = "nix develop ./";
      "nr" = "nix run";

      "jn" = "jupyter notebook";

      "cp" = "advcp -g";
      "mv" = "advmv -g";

      "gt" = "gcc -g -O0 -Wp,-U_FORTIFY_SOURCE";

      "ls" = "nnn -de";
    };

    shellInit = ''

      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
      source ${pkgs.zsh-fzf-history-search}/share/zsh-fzf-history-search/zsh-fzf-history-search.plugin.zsh
      # source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh

      setxkbmap -option grp:caps_toggle -layout us,ru

      # if [ -z "$TMUX" ] && [ -n "$DISPLAY" ]; then
      #   tmux attach-session -t default || tmux new-session -s default
      # fi

      if [ -z "$TMUX" ] && [ -n "$DISPLAY" ]; then
        if ! tmux has-session -t default 2>/dev/null; then
          tmux new-session -s default
        fi
        tmux attach-session -t default
      fi

      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      export EDITOR="nvim"
      export TERMINAL="alacritty";
      export BROWSER="firefox"

      #-----
      export NNN_OPTS="r"
      export LC_COLLATE="C" # hidden files on top
      export NNN_FIFO="/tmp/nnn.fifo"
      export NNN_PLUG='p:preview-tui;f:fzopen;F:fzcd;d:dragdrop;j:autojump;x:!chmod +x "$nnn";k:gitroot;t:nvim'
      #-----

      n ()
      {

          if [ -n $NNNLVL ] && [ "${fuck}{NNNLVL:-0}" -ge 1 ]; then
              echo "nnn is already running"
              return
          fi
          export NNN_TMPFILE="${fuck}{XDG_CONFIG_HOME:-${fuck}HOME/.config}/nnn/.lastd"
          nnn "$@"
          if [ -f "$NNN_TMPFILE" ]; then
                  . "$NNN_TMPFILE"
                  rm -f "$NNN_TMPFILE" > /dev/null
          fi
      }

    '';
  };
}
