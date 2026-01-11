### --- [ ОСНОВНЫЕ УТИЛИТЫ  ] ---

abbr -a ls lsd
abbr -a sl lsd
abbr -a l 'lsd -al'
alias cat 'bat --theme-dark gruvbox-dark'
abbr -a mv 'mv -v'
abbr -a cp xcp
abbr -a rm "echo Use 'rip' instead of rm" # Безопасное удаление
alias wget "curl -L -O"

### --- [ НАВИГАЦИЯ И ПОИСК ] ---

abbr -a f br
abbr -a fh br ~/
abbr -a ft br /tmp
abbr -a tree "br -c :pt ."

function z
    cd & br --only-folders --cmd "$argv[1];:cd"
end

function size
    br -c :pt $argv -w
end

### --- [ РАЗРАБОТКА: JUST ] ---

abbr -a j just
abbr -a jd "just --dry-run"
abbr -a jl 'just --list'
abbr -a jr "just run"
abbr -a jt "just test"
abbr -a jb "just build"
abbr -a jg "just debug"

### --- [ РАЗРАБОТКА: GIT ] ---

abbr -a gs 'br --git-status -ghc :pt'
abbr -a ga 'git add .'
abbr -a gc 'git checkout'
abbr -a gm 'git commit -m'
abbr -a gp 'git push'
abbr -a gl 'git log'
abbr -a gsw 'git switch'

### --- [ РАЗРАБОТКА: NIX & EDITORS ] ---

abbr -a nv nvim
abbr -a nvi 'nvim ~/note/index.md'
abbr -a ns nix-shell
abbr -a nr "nix run"
abbr -a nd "nix develop ./"

### --- [ СИСТЕМА И ЖЕЛЕЗО ] ---

abbr -a bstop "sudo systemctl stop bluetooth.service"
alias na "bluetoothctl connect E4:61:F4:31:88:26"
abbr -a weather "curl v2d.wttr.in/47.42,40.09"
abbr -a tt taskwarrior-tui

### --- [ МУЛЬТИМЕДИА И ДОКУМЕНТЫ ] ---

function zathura
    command niri msg action spawn -- zathura "$PWD/$argv"
end

function vi
    nohup vimiv * --command 'enter thumbnail' >/dev/null 2>&1 &
end

function d
    pushd .
    cd ~/note/journal && zk dd "$argv" && popd
end

function pdf2text
    nix-shell -p poppler-utils --run "pdftotext \"$argv[1]\" \"$argv[2]\""
end

### --- [ СКРИПТЫ ] ---

alias timr "~/work/timer/target/release/timer -s '󰀠  Alarm!' -b 'Timeout' -d"
alias alrm "~/work/timer/target/release/timer -m alarm -s '󰀠  Alarm!' -b 'Timeout' -d"
abbr tg "QT_QPA_PLATFORMTHEME=xdgdesktopportal Telegram"
