{pkgs, ...}: let
  fuck = "$";
in {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      "na" = "bluetoothctl connect E4:61:F4:31:88:26";
      ".." = "cd ..";

      "hms" = "nh home switch --ask /home/replica/nix/ && dunstify '  NixOS' 'Home switch done 󰄬' || dunstify -u critical -h string:fgcolor:#f38ba8 '  NixOS' 'Home switch failed ❌' -t 4000";
      "nrs" = "nh os switch --ask /home/replica/nix/ && dunstify '  NixOS' 'Nix switch done 󰄬' || dunstify -u critical -h string:fgcolor:#f38ba8 '  NixOS' 'Home switch failed ❌' -t 4000";

      "nix clean" = "nh clean && dunstify '  NixOS' 'Clean done 󰄬' || dunstify -u critical -h string:fgcolor:#f38ba8 '  NixOS' 'Clean failed ❌' -t 4000";

      "nv" = "nvim";
      "nb" = "nix build ./";
      "nd" = "nix develop ./";
      "nr" = "nix run";

      "jn" = "jupyter notebook";

      # "cp" = "advcp -g";
      # "mv" = "advmv -g";

      "gt" = "gcc -g -O0 -Wp,-U_FORTIFY_SOURCE";

      # "d" = "~/nix/static/sh/tmux.sh";

      "ext" = "~/nix/static/sh/ext.sh";

      "record" = "~/nix/static/sh/record.sh";
      "recordA" = "~/nix/static/sh/recordA.sh";

      "jc" = "cd ~/notes/ && nvim ./index.norg";

      "en" = "euporie notebook";
      "ec" = "euporie console";
      "ep" = "euporie preview";

      # "ls" = "nnn -de";
      # "ls" = "br -dp";
    };

    # source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
    initContent = ''
      source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

      setxkbmap -option grp:caps_toggle -layout us,ru

      source ${pkgs.fzf}/share/fzf/completion.zsh

      export FZF_COMPLETION_DIR_COMMANDS="cd pushd rmdir tree"
      export FZF_COMPLETION_TRIGGER="**"

      source ${pkgs.fzf}/share/fzf/key-bindings.zsh

      export FZF_CTRL_T_OPTS="--height 10% \
      --cycle \
      --layout reverse \
      --prompt 'F/D pwd: ' \
      --header='Ctrl-n/p: move | Ctrl-Y: copy | Alt-Y: copy \$PWD |  '
      --preview 'bat --style=numbers --color=always --no-pager --line-range :50 {}' \
      --bind \"ctrl-y:execute-silent(echo {} | awk '{printf \\\"%s\\\", \$0}' | xclip -sel clip)+abort\" \
      --bind \"alt-y:execute-silent(echo $PWD/{} | awk '{printf \\\"%s\\\", \$0}' | xclip -sel clip)+abort\" \
      --preview-window=right:5:50%"

      export FZF_CTRL_R_OPTS="--height 10% \
      --cycle \
      --layout reverse \
      --prompt 'History: ' \
      --bind \"ctrl-y:execute-silent(echo {} | sed 's/[0-9]//g' | awk '{printf \\\"%s\\\", \$0}' | xclip -sel clip)+abort\" \
      --header='Ctrl-j/k: move | Ctrl-Y: copy | 󰄛 '"

      export FZF_ALT_C_OPTS="--height 10% \
      --cycle \
      --prompt 'CD ~/' \
      --header='Ctrl-n/p: move | Ctrl-Y: copy | Alt-Y: copy \$PWD |  '
      --bind \"ctrl-y:execute-silent(echo {} | awk '{printf \\\"%s\\\", \$0}' | xclip -sel clip)+abort\" \
      --bind \"alt-y:execute-silent(echo $PWD/{} | awk '{printf \\\"%s\\\", \$0}' | xclip -sel clip)+abort\" \
      --preview 'ls -a --color=always {} 2>/dev/null'
      --preview-window=right:5:50%"


      bindkey -v

      setopt CORRECT
      setopt NO_CLOBBER

      export EDITOR="nvim"
      export VISUAL="nvim"
      export TERMINAL="wezterm"
      export BROWSER="qutebrowser"

      export FZF_DEFAULT_OPTS="
        --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
        --color=fg:#cdd6f4,header:#f38ba8,info:#89b4fa,pointer:#f5e0dc
        --color=marker:#89b4fa,fg+:#cdd6f4,prompt:#89b4fa,hl+:#f38ba8
        --color=selected-bg:#45475a
        --color=border:#313244,label:#cdd6f4"
        # --layout=reverse"
        # --border-label="fzf!" --border-label-pos="0"

      if [[ -r "${fuck}{XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${fuck}{(%):-%n}.zsh" ]]; then
         source "${fuck}{XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${fuck}{(%):-%n}.zsh"
      fi

      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

    '';
  };
}
