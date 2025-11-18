function ..
    cd ..
end
function ...
    cd ../..
end
function ....
    cd ../../..
end
function .....
    cd ../../../..
end

function grep
    command grep --color=auto $argv
end

function zathura
    command niri msg action spawn -- zathura "$PWD/$argv"
end

abbr -a mv 'mv -v'
abbr -a rm 'rm -v'
abbr -a cp 'cp -v'

abbr -a bstop "sudo systemctl stop bluetooth.service"

abbr -a sl lsd
abbr -a ls lsd
abbr -a l 'lsd -al'
abbr -a tree "lsd --tree"

alias cat 'bat --theme-dark gruvbox-dark'

abbr -a gp 'git push'
abbr -a gsw 'git switch'
abbr -a gc 'git checkout'
abbr -a ga 'git add .'
abbr -a gs 'git status'
abbr -a gl 'git log'
abbr -a gm 'git commit -m'

abbr -a j just
abbr -a jr "just run"
abbr -a jt "just test"
abbr -a jb "just build"
abbr -a jg "just debug"
abbr -a jc "just clippy"

abbr -a book "$HOME/note/book"

alias gitmainormaster="printf '%s\n' (git branch --format '%(refname:short)' --sort=-committerdate --list master main)  main | head -n 1"
alias main="git checkout (gitmainormaster)"

alias wget="curl -L -O"

abbr -a ns nix-shell
abbr -a nd "nix develop ./"
abbr -a nr "nix run"
abbr -a nv nvim

alias vi "vimiv * --command 'enter thumbnail'"

function d
    pushd .
    cd ~/note/journal && zk dd "$argv" && popd
end

abbr -a nvi 'nvim ~/note/index.md'
abbr -a nvf 'nvim ~/nix/fish/config.fish'

function pdf2text
    nix-shell -p poppler-utils --run "pdftotext "$argv[1]" "$argv[2]""
end

abbr -a swork "~/nix/**/work.sh ."
alias book "source ~/nix/niri/niri_book_setup.fish"

alias timr "~/work/timer/target/release/timer -s '󰀠  Alarm!' -b 'Timeout' -d"
alias alrm "~/work/timer/target/release/timer -m alarm -s '󰀠  Alarm!' -b 'Timeout' -d"

abbr -a weather "curl v2d.wttr.in/47.42,40.09"

abbr -a t task
abbr -a tt taskwarrior-tui
abbr -a h "task rc.data.location=~/.habit"
abbr -a tth "taskwarrior-tui --taskdata ~/.habit"

alias na "bluetoothctl connect E4:61:F4:31:88:26"
alias nrs 'nh os switch --ask /home/replica/nix/ && dunstify "  NixOS" "Nix switch done 󰄬" || dunstify -u critical -h string:fgcolor:#f38ba8 "  NixOS" "Home switch failed ❌" -t 4000'
