alias ls 'eza --icons=auto --group-directories-first'
abbr sl ls
alias l 'eza -al --icons=auto --git-repos --git -h --group-directories-first --smart-group'
alias cat 'bat --theme-dark gruvbox-dark'
abbr -a mv 'mv -v'
abbr -a cp 'cp -v'
abbr -a rm "echo Use 'rip' instead of rm"
abbr vi lsix
alias wget "curl -L -O"

function f
    set -l target (fd | fzf)

    if test -n "$target"
        if test -d "$target"
            cd "$target"
        else
            nvim "$target"
        end
    end
end

alias tree "eza --tree --level=3 --icons=always --git-ignore"

abbr -a size "du -h | rg -v -e .git -v -e .jj | sort -hr | head -30"

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

abbr aria "aria2c -x 16 -s 16 -c"

abbr dev 'distrobox enter dev'
abbr devs 'distrobox stop dev'
abbr drun 'distrobox enter dev --'

abbr qu exit
