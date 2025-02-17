{pkgs, ...}: let
  fuck = "$";
in {
  users.defaultUserShell = pkgs.zsh;

  environment.systemPackages = with pkgs; [
    zsh-powerlevel10k
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      "na" = "bluetoothctl connect E4:61:F4:31:88:26";
      ".." = "cd ..";

      "hms" = "home-manager switch --flake ~/nix/";
      "nrs" = "sudo nixos-rebuild switch --flake ~/nix/";

      "systemState" = "ls -l /nix/var/nix/gcroots/auto";

      "nv" = "nvim .";
      "nb" = "nix build ./";
      "nd" = "nix develop ./";
      "nr" = "nix run";

      "jn" = "jupyter notebook";

      "cp" = "advcp -g";
      "mv" = "advmv -g";
      "tor" = "qbittorrent";
    };

    # plugins = [
    #   {name = "zsh-users/zsh-autosuggestions";}
    #   {
    #     name = "powerlevel10k";
    #     src = pkgs.zsh-powerlevel10k;
    #   }
    # ];
    shellInit = ''
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
      export NNN_FIFO=/tmp/nnn.fifo
      export NNN_OPTS="r"
      export LC_COLLATE="C" # hidden files on top
      export NNN_FIFO="/tmp/nnn.fifo"
      export NNN_PLUG='p:preview-tabbed;F:fzopen;f:fzcd;d:dragdrop'
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

    # plugins = [
    #   {
    #     name = "powerlevel10k";
    #     src = pkgs.zsh-powerlevel10k;
    #     file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    #   }
    # ];

    # zplug = {
    #   enable = true;
    #   plugins = [
    #     {name = "zsh-users/zsh-autosuggestions";}
    #   ];
    # };

    # oh-my-zsh = {
    #   enable = true;
    #   plugins = ["git" "thefuck" "z" "sudo"];
    #   theme = "agnoster";
    #   extraConfig = '''';
    # };
  };
}
