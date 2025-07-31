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

# fd() {
#   local pattern="$1"
#   shift
#
#   if [ -z "$pattern" ] || [ "${pattern:0:1}" != "-" ]; then
#     pattern="*"
#   fi
#
#   # if [ -z "$pattern" ]; then
#   #   pattern="*"
#   # fi
#
#   find . -name "$pattern" "$@"
# }
#
# alias find="fd"

ff() {
  find_file=$(find . \( -path "**/venv" -o -path "**/__*" -o -path "**/.*" -o -path "**/WinShareDir" -o -path "**/_minted" \) -prune -o -type f -print | fzf -m --preview "bat --style=numbers --color=always --line-range=:100 {}" --preview-window=down)

  if [ -z "$find_file" ]; then
    return 0
  fi

  echo "$find_file"
}

nvf() {
  ff=$(ff)

  if [ -z "$ff" ]; then
    return 0
  fi

  nvim "$ff"
}

alias nvi='nv ~/note/index.md'
alias nvb='nv ~/nix/**/.bashrc'
alias sbrc="source ~/.bashrc"

alias cat="bat"

zf() {
  fzf_prompt=$(find . -name "*.pdf" -o -name "*.djvu" -o -name "*.fb2" | fzf)

  if [ -z "$fzf_prompt" ]; then
    return 0
  fi

  zathura "$fzf_prompt"
}

mpvf() {
  fzf_prompt=$(find . -name "*.mp4" -o -name "*.mkv" -o -name "*.avi" -o -name "*.mov" -o -name "*.webm" -o -name "*.flv" -o -name "*.mpeg" -o -name "*.mpg" -o -name "*.wmv" -o -name "*.3gp" -o -name "*.ts" -o -name "*.m4v" -o -name "*.ogv" -o -name "*.mov" | fzf)

  if [ -z "$fzf_prompt" ]; then
    return 0
  fi

  mpv "$fzf_prompt"
}

cdf() {
  path=$(find . \( -path "**/venv" -o -path "**/__*" -o -path "**/.*" -o -path "**/WinShareDir" -o -path "**/_minted" \) -prune -o -type d -print | fzf --preview="ls {}" --preview-window=down)
  cd "$path" || exit 0

  if [ -z "$path" ]; then
    return 0
  fi

  path=$(realpath --relative-to="$HOME" "$PWD")
  echo "~/$path"
}

hf() {
  fzf_prompt=$(history | sort -hr | fzf | cut -c 8-)

  if [ -z "$fzf_prompt" ]; then
    return 0
  fi

  $fzf_prompt
}

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

export PROMPT_DIRTRIM=2

bind Space:magic-space

bind "set completion-ignore-case on"

bind "set completion-map-case on"

# bind "set show-all-if-ambiguous on"

bind "set mark-symlinked-directories on"

export PROMPT_COMMAND='history -a'

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
