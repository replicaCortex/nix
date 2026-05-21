### --- [ ОСНОВНЫЕ УТИЛИТЫ  ] ---

alias ls 'eza --icons=auto --group-directories-first'
abbr sl ls
alias l 'eza -al --icons=auto --git-repos --git -h --group-directories-first --smart-group --color-scale=all'
alias cat 'bat --theme-dark gruvbox-dark'
abbr -a mv 'mv -v'
abbr -a cp 'cp -v'
abbr -a rm "echo Use 'rip' instead of rm"
abbr vi lsix
alias wget "curl -L -O"

### --- [ НАВИГАЦИЯ И ПОИСК ] ---

abbr -a f br
abbr -a fh br ~/
abbr -a ft br /tmp
abbr -a tree "br -c :pt ."

function size
    br -c :pt $argv -w
end

abbr -a j just
abbr -a jd "just --dry-run"
abbr -a jl 'just --list'
abbr -a jr "just run"
abbr -a jt "just test"
abbr -a jb "just build"
abbr -a jg "just debug"

abbr -a nv nvim
abbr -a ns nix-shell
abbr -a nr "nix run"
abbr -a nd "nix develop ./"

abbr -a bstop "sudo systemctl stop bluetooth.service"
abbr -a na "bluetoothctl connect E4:61:F4:31:88:26"
abbr -a weather "curl v2d.wttr.in/47.42,40.09"
abbr -a tt taskwarrior-tui

function zathura
    command niri msg action spawn -- zathura "$PWD/$argv"
end

function docx2pdfp
    pandoc "$argv[1]" -o "$argv[2]" --pdf-engine=typst --extract-media=./typst_media -V mainfont="DejaVu Sans" && rm -rf ./typst_media
end

function docx2pdf
    pandoc "$argv[1]" -o "$argv[2]" --pdf-engine=typst --extract-media=./typst_media -V mainfont="DejaVu Sans" && rm -rf ./typst_media
end

function open
    set -l app $argv[1]
    set -l file_path $argv[2]

    function niri_open
        niri msg action spawn-sh -- $argv
    end

    if not count $file_path
        niri_open $app
    else
        niri_open "$app $PWD/$file_path"
    end

end

abbr aria "aria2c -x 16 -s 16 -c"

abbr dev 'distrobox enter dev'
abbr devs 'distrobox stop dev'
abbr qu exit
abbr drun 'distrobox enter dev --'
