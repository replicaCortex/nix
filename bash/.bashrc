alias na="bluetoothctl connect E4:61:F4:31:88:26"
alias nix-clean='nh clean && dunstify "  NixOS" "Clean done 󰄬" || dunstify -u critical -h string:fgcolor:#f38ba8 "  NixOS" "Clean failed ❌" -t 4000'
alias nrs='nh os switch --ask /home/replica/nix/ && dunstify "  NixOS" "Nix switch done 󰄬" || dunstify -u critical -h string:fgcolor:#f38ba8 "  NixOS" "Home switch failed ❌" -t 4000'

ns() {
  nix-shell "$@" --run "exec bash"
}
alias nb="nix build ./"
alias nd="nix develop ./"
alias nr="nix run"
alias nv="nvim"

alias bstar="sudo systemctl start bluetooth.service && na"
alias bstop="sudo systemctl stop bluetooth.service"
alias ext="~/nix/**/ext.sh"
alias replace="~/nix/**/replace.sh"

alias vi="vimiv * --command 'enter thumbnail'"
alias cdo='cd "$(echo $OLDPWD)"'

alias cat="bat --theme-dark gruvbox-dark"
alias l="lsd -al"
alias ls="lsd"
alias lt='ls --tree'

w2q() {
  nix-shell -p quarto pandoc --run "quarto pandoc -f docx -t markdown -o \"$2\" \"$1\" --extract-media=./images"
}

d2p() {
  nix-shell -p quarto pandoc texlive.combined.scheme-full --run "pandoc --pdf-engine=lualatex \
    -V documentclass=scrartcl \
    -V fontsize=14pt \
    --lua-filter=$HOME/nix/bash/lua_filters_for_pandoc.lua \
    -H $HOME/nix/bash/header.tex \
    -o \"$2\" \"$1\""
}

ZkDayli() {
  cd ~/note/journal && zk dd "$*" && cdo
}

alias d="ZkDayli"

alias nvi='nv ~/note/index.md'
alias nvb='nv ~/nix/**/.bashrc'
alias sbrc="source ~/.bashrc"

# yt-dlp() {
#   nix-shell -p yt-dlp --run "yt-dlp --proxy=\"$PROXY\" \"$1\""
# }

pdf2text() {
  nix-shell -p poppler-utils --run "pdftotext \"$1\" \"$2\""
}

alias work="~/nix/**/work.sh ."

alias book="source ~/nix/**/niri_book_setup.sh"

zathura() {
  niri msg action spawn -- zathura "$PWD/$1"
}

alias music="source ~/nix/**/music_setup.sh"

alias timr="~/work/timer/target/release/timer -s '󰀠  Alarm!' -b 'Timeout' -d"
alias alrm="~/work/timer/target/release/timer -m alarm -s '󰀠  Alarm!' -b 'Timeout' -d"

alias weather="curl v2d.wttr.in/47.42,40.09"

alias csetup="~/nix/**/csetup.sh"
alias psetup="~/nix/**/psetup.sh"
alias qsetup="~/nix/**/qsetup.sh"
alias rsetup="~/nix/**/rsetup.sh"

alias t="task"
alias tt="taskwarrior-tui"
alias h="task rc.data.location=~/.habit"
alias tth="tt --taskdata ~/.habit"

# ---

export BROWSER="zen"
export EDITOR="nvim"
export TERMINAL="foot"
export VISUAL="nvim"

# export http_proxy="$PROXY"
# export https_proxy="$PROXY"

# ---

export PROMPT_DIRTRIM=2

PROMPT_COMMAND="history -a${PROMPT_COMMAND:+;}$PROMPT_COMMAND"

export HISTCONTROL="erasedups:ignoreboth:ignoredups"
export HISTIGNORE="&:[ ]*:exit:ls:l:cdf:mpvf:hf:zf:bg:fg:history:clear:nv:nvf:find:fzf:history:vi:cd:nix-shell:ды:св:n:s"

export HISTFILESIZE=100000
export HISTSIZE=10000

stty -ixon

shopt -s histappend
shopt -s checkwinsize
shopt -s extglob
shopt -s globstar
shopt -s checkjobs
shopt -s cmdhist

shopt -s autocd 2>/dev/null
shopt -s dirspell 2>/dev/null
shopt -s cdspell 2>/dev/null

set -o noclobber

# Commands that should be applied only for interactive shells.
[[ $- == *i* ]] || return

# ---

. ~/nix/bash/git-prompt.sh
PROMPT_COMMAND='PS1_CMD1=$(__git_ps1 "(%s)")'
PS1='\n\[\e[93m\]\u\[\e[93m\]@\[\e[93m\]\h\[\e[93m\][\[\e[93m\]$?\[\e[93m\]]\[\e[95m\]${PS1_CMD1}\[\e[93m\]:\n\[\e[38;5;110m\]\w\[\e[0m\] '

# export LESS='-RFiXN'
export MANPAGER="sh -c 'awk '\''{ gsub(/\x1B\[[0-9;]*m/, \"\", \$0); gsub(/.\x08/, \"\", \$0); print }'\'' | bat -p -lman'"
