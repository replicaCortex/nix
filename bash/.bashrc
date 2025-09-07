alias na="bluetoothctl connect E4:61:F4:31:88:26"
alias nrs='nh os switch --ask /home/replica/nix/ && dunstify "  NixOS" "Nix switch done 󰄬" || dunstify -u critical -h string:fgcolor:#f38ba8 "  NixOS" "Home switch failed ❌" -t 4000'
alias nix-clean='nh clean && dunstify "  NixOS" "Clean done 󰄬" || dunstify -u critical -h string:fgcolor:#f38ba8 "  NixOS" "Clean failed ❌" -t 4000'

alias sh="~/work/shedule/a.out"
alias shf="~/work/shedule/a.out -f"

alias nv="nvim"
alias nb="nix build ./"
alias nd="nix develop ./"
alias nr="nix run"
alias ns="nix-shell"

alias ext="~/nix/**/ext.sh"
alias replace="~/nix/**/replace.sh"
alias bstar="sudo systemctl start bluetooth.service && na"
alias bstop="sudo systemctl stop bluetooth.service"

alias record="~/nix/**/record.sh"
alias recordA="~/nix/**/recordA.sh"
alias recordV="~/nix/**/record_voise.sh"
alias recordVT="~/nix/**/trash_record_voise.sh"

alias vi="vimiv * --command 'enter thumbnail'"
alias cdo='cd "$(echo $OLDPWD)"'

word2quarto() {
  quarto pandoc -f docx -t markdown -o "$2" "$1" --extract-media=./images
}

alias w2q=word2quarto

ZkDayli() {
  cd ~/note/journal && zk dd "$*" && cdo
}

alias d="ZkDayli"

alias nvi='nv ~/note/index.md'
alias nvb='nv ~/nix/**/.bashrc'
alias sbrc="source ~/.bashrc"

alias yt-dlp='yt-dlp --proxy "$PROXY"'

alias work="~/nix/**/work_setup.sh"
alias work.='work "$PWD"'

alias book="source ~/nix/**/book_setup.sh"
alias standart="~/nix/**/standart_setup.sh"

alias timr="~/nix/**/timr-tui -d -n=on --blink=on -c"

# ---

export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="foot"
export BROWSER="zen"
export PROXY="https://openproxy:2ad5c3cece9f19f6@nl-hub.freeruproxy.ink:443"
# export http_proxy="$PROXY"
# export https_proxy="$PROXY"

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
alias grep='grep --color=always -n -i'
alias ls='ls --color=always'
