alias ls 'eza --icons=auto --group-directories-first'
abbr sl ls
alias l 'eza -al --icons=auto --git-repos --git -h --group-directories-first --smart-group'
alias cat 'bat --theme-dark gruvbox-dark'
abbr -a mv 'mv -vn'
abbr -a cp 'cp -v'
abbr -a rm "echo Use 'rip' instead of rm"
abbr -a wl-paste 'wl-paste -n '
alias wget "curl -L -O"

function f
    set -l tmp_file "/tmp/fzf_cd_$fish_pid"

    rm -f $tmp_file

    $DOTFILES/terminal/scripts/pick.sh $argv

    if test -f $tmp_file
        set -l target_dir (cat $tmp_file)
        rm -f $tmp_file
        cd "$target_dir"
    end
end

alias vi "ls | sort | $DOTFILES/terminal/scripts/vidir.sh"
alias vid "fd -t d | sort | $DOTFILES/terminal/scripts/vidir.sh"
alias vif "fd -t f | sort | $DOTFILES/terminal/scripts/vidir.sh"
alias tree "eza --tree --level=3 --icons=always --git-ignore"
alias norm $DOTFILES/terminal/scripts/normalize.sh

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

function zathura
    command niri msg action spawn -- zathura "$PWD/$argv"
end

abbr aria "aria2c -x 16 -s 16 -c"

abbr dev 'distrobox enter dev'
abbr devs 'distrobox stop dev'
abbr drun 'distrobox enter dev --'

abbr qu exit
