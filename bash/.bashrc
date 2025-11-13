alias na="bluetoothctl connect E4:61:F4:31:88:26"
alias nrs='nh os switch --ask /home/replica/nix/ && dunstify "  NixOS" "Nix switch done 󰄬" || dunstify -u critical -h string:fgcolor:#f38ba8 "  NixOS" "Home switch failed ❌" -t 4000'
alias nix-clean='nh clean && dunstify "  NixOS" "Clean done 󰄬" || dunstify -u critical -h string:fgcolor:#f38ba8 "  NixOS" "Clean failed ❌" -t 4000'

alias nv="nvim"
alias nb="nix build ./"
alias nd="nix develop ./"
alias nr="nix run"
alias ns="nix-shell"

alias ext="~/nix/**/ext.sh"
alias replace="~/nix/**/replace.sh"
alias bstar="sudo systemctl start bluetooth.service && na"
alias bstop="sudo systemctl stop bluetooth.service"

alias vi="vimiv * --command 'enter thumbnail'"
alias cdo='cd "$(echo $OLDPWD)"'

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

export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="foot"
export BROWSER="zen"
export PROXY="http://c32ec17997961bcd87241ba05d14bcbd:c32ec17997961bcd87241ba05d14bcbd@5.199.143.188:5598"

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

export LESS='-RFiXN'
alias less="less --use-color --status-line"
# alias grep='grep --color=always -n -i'
# alias ls='ls --color=always'
