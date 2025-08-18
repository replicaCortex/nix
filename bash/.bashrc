alias na="bluetoothctl connect E4:61:F4:31:88:26"
alias nrs='nh os switch --ask /home/replica/nix/ && dunstify "  NixOS" "Nix switch done 󰄬" || dunstify -u critical -h string:fgcolor:#f38ba8 "  NixOS" "Home switch failed ❌" -t 4000'
alias nix-clean='nh clean && dunstify "  NixOS" "Clean done 󰄬" || dunstify -u critical -h string:fgcolor:#f38ba8 "  NixOS" "Clean failed ❌" -t 4000'

alias nv="nvim"
alias nb="nix build ./"
alias nd="nix develop ./"
alias nr="nix run"
alias ns="nix shell"

alias ext="~/nix/bash/ext.sh"

alias record="~/nix/bash/record.sh"
alias recordA="~/nix/bash/recordA.sh"
alias recordV="~/nix/bash/record_voise.sh"
alias recordVT="~/nix/bash/trash_record_voise.sh"

alias vi="vimiv * --command 'enter thumbnail'"
alias gcc="gcc -Wall -Wextra -Wpedantic"
alias d="cd ~/note && zk d"
alias cdo='cd "$(echo $OLDPWD)"'

alias nvi='nv ~/note/index.md'
alias nvb='nv ~/nix/**/.bashrc'
alias sbrc="source ~/.bashrc"

alias yt-dlp='yt-dlp --proxy "$PROXY"'

alias cat="bat"

alias work="~/nix/**/work_setup.sh"
alias work.='work "$PWD"'

alias book="source ~/nix/**/book_setup.sh"

# ---

# Включение Vi mode
set -o vi

# Опции bash
set -o noclobber

# Export Environment Variables
export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="foot"
export BROWSER="zen"
export PROXY="https://openproxy:2ad5c3cece9f19f6@nl-hub.freeruproxy.ink:443"

export PROMPT_DIRTRIM=2

bind Space:magic-space

bind "set completion-ignore-case on"

bind "set completion-map-case on"

# bind "set show-all-if-ambiguous on"

bind "set mark-symlinked-directories on"

PROMPT_COMMAND="history -a${PROMPT_COMMAND:+;}$PROMPT_COMMAND"

stty -ixon

export HISTCONTROL="erasedups:ignoreboth:ignoredups"
export HISTIGNORE="&:[ ]*:exit:ls:l:cdf:mpvf:hf:zf:bg:fg:history:clear:nv:nvf:find:fzf:history:vi:cd:nix-shell:ды:св"

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
