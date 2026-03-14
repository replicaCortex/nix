function niri_spawn $argv
    niri msg action spawn -- $argv
end

function niri_spawn_sh
    niri msg action spawn-sh -- $argv
end

function launch
    set -l input_text $argv
    set -l path_to_poses $HOME/art/krita/assets/real_poses2/

    if test -z "$input_text"
        read -P (set_color green)"Search: "(set_color normal) -l user_input
        if test -z "$user_input"
            exit
        end
        set input_text $user_input
    end

    set -l cmd (echo $input_text | cut -d' ' -f1)
    set -l rest (echo $input_text | cut -d' ' -f2-)
    if test "$cmd" = "$input_text"
        set rest ""
    end

    switch $cmd
        case go пщ
            set url "https://aistudio.google.com/prompts/new_chat"
        case nix тшч
            set url "https://search.nixos.org/packages?channel=unstable"
        case tr ек
            set url "https://translate.google.com/?hl=en"
        case ytr нек
            set url "https://translate.yandex.com/?source_lang=en&target_lang=ru&text="
        case an фт
            set url "https://annas-archive.gl/"
        case img шьп
            set url "https://gelbooru.com/index.php?page=post&s=list&tags=all"
        case re ку
            set url "https://old.reddit.com/"
        case de ву
            set url "https://chat.deepseek.com/"
        case qw йц
            set url "https://chat.qwen.ai/"
        case dr вк
            set url "https://www.tldraw.com/"
        case du вг
            set url "https://duckduckgo.com/?q=DuckDuckGo+AI+Chat&ia=chat&duckai=1"
        case git пше
            set url "https://github.com/"
        case ng тп
            set url "https://www.newgrounds.com/"
        case 2ch 2ср
            set url "https://2ch.su/"
        case w ц
            set url "https://web.whatsapp.com/"
        case rev кум
            set url "https://context.reverso.net/translation/english-russian/"
        case sh ыр
            set url "https://npi-tu.ru/schedule/schedule.html?for=student&faculty=2&year=3&group=%D0%9F%D0%9E%D0%92%D0%B0"
        case wo цщ
            set url "https://docs.google.com/document/u/0/"
        case be иу
            set url "https://rostov-na-donu.beeline.ru/customers/products/elk/"
        case sdo ывщ
            set url "https://sdo.npi-tu.ru/"
        case vk мл
            set url "https://vk.com/im"
        case manga ьфтпф
            set url "https://mangadex.org/titles/follows"
        case qp йз
            set url "https://posemy.art/quick-poses/"
        case al фд
            set url "https://alice.yandex.ru/"
        case ar фк
            set url "https://arena.ai/?mode=direct"
        case sp
            niri_spawn_sh "gesture-drawing -p $path_to_poses -m -t 30 -c 20 -d 5 -s " & sleep 2 && niri msg action set-column-width 1870
        case mp
            niri_spawn_sh "gesture-drawing -p $path_to_poses -t 60 -c 10 -d 5 -s -m" & sleep 2 && niri msg action set-column-width 1870
        case lp
            niri_spawn_sh "gesture-drawing -p $path_to_poses -t 120 -c 5 -d 5 -s -m" & sleep 2 && niri msg action set-column-width 1870

        case '*'
            set -l selected (ddgr -n 25 --noua --json --noprompt $input_text | \
                             jq -r '.[] | "\(.title) \t \(.url)"' | \
                             fzf --delimiter \t --with-nth 1 --reverse --layout=reverse --header "Searching for: $input_text")

            if test $status -eq 0; and test -n "$selected"
                set url (echo $selected | cut -f2 | string trim)
            else
                exit
            end
    end

    if test -n "$url"
        niri_spawn_sh "zen \"$url\""
    end
end
