alias na="bluetoothctl connect E4:61:F4:31:88:26"
alias nrs='nh os switch --ask /home/replica/nix/ && dunstify "  NixOS" "Nix switch done 󰄬" || dunstify -u critical -h string:fgcolor:#f38ba8 "  NixOS" "Home switch failed ❌" -t 4000'
alias nix-clean='nh clean && dunstify "  NixOS" "Clean done 󰄬" || dunstify -u critical -h string:fgcolor:#f38ba8 "  NixOS" "Clean failed ❌" -t 4000'

alias nv="nvim"
alias nb="nix build ./"
alias nd="nix develop ./"
alias nr="nix run"
alias ns="nix shell"

alias ext="~/nix/static/sh/ext.sh"

alias record="~/nix/static/sh/record.sh"
alias recordA="~/nix/static/sh/recordA.sh"

alias vi="vimiv * --command 'enter thumbnail'"

alias ff='find . \( -path "./.git" -o -path "./.venv" -o -path "./.*py*" -o -path "./*__*" \) -prune -o \( -type f -o -type d \) -print | fzf -m --preview "bat --style=numbers --color=always --line-range=:100 {}" --preview-window=down'
alias nvf='nv $(ff)'

alias cat="bat"

# Включение Vi mode
set -o vi

# Опции bash
set -o noclobber

# Export Environment Variables
export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="foot"
export BROWSER="zen"

export PROMPT_DIRTRIM=2

bind Space:magic-space

shopt -s globstar 2>/dev/null

bind "set completion-ignore-case on"

bind "set completion-map-case on"

# bind "set show-all-if-ambiguous on"

bind "set mark-symlinked-directories on"

export PROMPT_COMMAND='history -a'

stty -ixon

export HISTCONTROL="erasedups:ignoreboth:ignoredups"
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear:nv:nvf:find:fzf:history:vi:cd:nix-shell"

# HISTTIMEFORMAT='%F %T '

shopt -s autocd 2>/dev/null
shopt -s dirspell 2>/dev/null
shopt -s cdspell 2>/dev/null

# Commands that should be applied only for interactive shells.
[[ $- == *i* ]] || return

export HISTFILESIZE=100000
export HISTSIZE=10000

shopt -s histappend
shopt -s checkwinsize
shopt -s extglob
shopt -s globstar
shopt -s checkjobs
shopt -s cmdhist
