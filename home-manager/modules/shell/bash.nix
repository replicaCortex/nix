{pkgs, ...}: {
  programs.bash = {
    enable = true;
    enableCompletion = true;

    bashrcExtra = ''
      alias na="bluetoothctl connect E4:61:F4:31:88:26"
      alias ..="cd .."
      alias hms='nh home switch --ask /home/replica/nix/ && dunstify "  NixOS" "Home switch done 󰄬" || dunstify -u critical -h string:fgcolor:#f38ba8 "  NixOS" "Home switch failed ❌" -t 4000'
      alias nrs='nh os switch --ask /home/replica/nix/ && dunstify "  NixOS" "Nix switch done 󰄬" || dunstify -u critical -h string:fgcolor:#f38ba8 "  NixOS" "Home switch failed ❌" -t 4000'
      alias nix-clean='nh clean && dunstify "  NixOS" "Clean done 󰄬" || dunstify -u critical -h string:fgcolor:#f38ba8 "  NixOS" "Clean failed ❌" -t 4000'

      alias nv="nvim"
      alias nb="nix build ./"
      alias nd="nix develop ./"
      alias nr="nix run"
      alias vi="vimiv * --command 'enter thumbnail'"

      alias jn="jupyter notebook"

      alias gt="gcc -g -O0 -Wp,-U_FORTIFY_SOURCE"

      alias ext="~/nix/static/sh/ext.sh"

      alias record="~/nix/static/sh/record.sh"
      alias recordA="~/nix/static/sh/recordA.sh"

      alias jc="cd ~/notes/ && nvim ./index.norg"

      alias en="euporie notebook"
      alias ec="euporie console"
      alias ep="euporie preview"

      source ~/nix/static/sh/bash-git-prompt/gitprompt.sh

      source ${pkgs.fzf}/share/fzf/completion.bash
      source ${pkgs.fzf}/share/fzf/key-bindings.bash

      # [[ $- = *i* ]] && source ${pkgs.liquidprompt}/bin/liquidprompt

      # FZF Environment Variables
      export FZF_COMPLETION_DIR_COMMANDS="cd pushd rmdir tree"
      export FZF_COMPLETION_TRIGGER="**" # Этот триггер не работает в bash

      # Параметры FZF
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

      # Включение Vi mode
      set -o vi

      # Опции bash
      set -o noclobber

      # Export Environment Variables
      export EDITOR="nvim"
      export VISUAL="nvim"
      export TERMINAL="foot"
      export BROWSER="qutebrowser"

      # FZF Default Options
      export FZF_DEFAULT_OPTS="
      --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
      --color=fg:#cdd6f4,header:#f38ba8,info:#89b4fa,pointer:#f5e0dc
      --color=marker:#89b4fa,fg+:#cdd6f4,prompt:#89b4fa,hl+:#f38ba8
      --color=selected-bg:#45475a
      --color=border:#313244,label:#cdd6f4"
      # --layout=reverse"
      # --border-label="fzf!" --border-label-pos="0"

      shopt -s checkwinsize

      PROMPT_DIRTRIM=2

      bind Space:magic-space

      shopt -s globstar 2>/dev/null

      bind "set completion-ignore-case on"

      bind "set completion-map-case on"

      bind "set show-all-if-ambiguous on"

      bind "set mark-symlinked-directories on"

      shopt -s histappend

      shopt -s cmdhist

      PROMPT_COMMAND='history -a'

      HISTSIZE=500000
      HISTFILESIZE=100000

      HISTCONTROL="erasedups:ignoreboth"

      export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear:nv"

      HISTTIMEFORMAT='%F %T '

      shopt -s autocd 2>/dev/null
      shopt -s dirspell 2>/dev/null
      shopt -s cdspell 2>/dev/null

      shopt -s cdable_vars
    '';
  };
}
