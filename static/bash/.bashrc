alias na="bluetoothctl connect E4:61:F4:31:88:26"
alias nrs='nh os switch --ask /home/replica/nix/ && dunstify "  NixOS" "Nix switch done 󰄬" || dunstify -u critical -h string:fgcolor:#f38ba8 "  NixOS" "Home switch failed ❌" -t 4000'
alias nix-clean='nh clean && dunstify "  NixOS" "Clean done 󰄬" || dunstify -u critical -h string:fgcolor:#f38ba8 "  NixOS" "Clean failed ❌" -t 4000'

alias nv="nvim"
alias nb="nix build ./"
alias nd="nix develop ./"
alias nr="nix run"

alias jn="jupyter notebook"

alias ext="~/nix/static/sh/ext.sh"

alias record="~/nix/static/sh/record.sh"
alias recordA="~/nix/static/sh/recordA.sh"
alias vi="vimiv * --command 'enter thumbnail'"

alias cat="bat"

source ~/nix/static/sh/bash-git-prompt/gitprompt.sh

# Включение Vi mode
set -o vi

# Опции bash
set -o noclobber

# Export Environment Variables
export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="foot"
export BROWSER="zen"

PROMPT_DIRTRIM=2

bind Space:magic-space

shopt -s globstar 2>/dev/null

bind "set completion-ignore-case on"

bind "set completion-map-case on"

# bind "set show-all-if-ambiguous on"

bind "set mark-symlinked-directories on"

PROMPT_COMMAND='history -a'

HISTCONTROL="erasedups:ignoreboth"

export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear:nv"

HISTTIMEFORMAT='%F %T '

shopt -s autocd 2>/dev/null
shopt -s dirspell 2>/dev/null
shopt -s cdspell 2>/dev/null

shopt -s cdable_vars

# Commands that should be applied only for interactive shells.
[[ $- == *i* ]] || return

HISTFILESIZE=100000
HISTSIZE=10000

shopt -s histappend
shopt -s checkwinsize
shopt -s extglob
shopt -s globstar
shopt -s checkjobs
shopt -s cmdhist
