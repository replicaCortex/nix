### --- [ ОСНОВНЫЕ УТИЛИТЫ  ] ---

abbr -a ls lsd
abbr -a sl lsd
abbr -a l 'lsd -al'
alias cat 'bat --theme-dark gruvbox-dark'
abbr -a mv 'mv -v'
abbr -a cp xcp
abbr -a rm "rm -v" 
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

abbr -a nv nvim
abbr -a world 'sudo nvim /var/lib/portage/world'
abbr -a pmake 'sudo nvim /etc/portage/make.conf'

abbr -a em 'sudo emerge --ask'
