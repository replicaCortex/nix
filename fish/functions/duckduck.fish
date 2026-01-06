function duckduck
    set -l input_text $argv

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
        case an фт
            set url "https://annas-archive.org/"
        case im шь
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

        case '*'
            set -l selected (ddgr --json --noprompt $input_text | \
                             jq -r '.[] | "\(.title) \t \(.url)"' | \
                             fzf --delimiter \t --with-nth 1 --reverse --layout=reverse --header "Searching for: $input_text")

            if test $status -eq 0; and test -n "$selected"
                set url (echo $selected | cut -f2 | string trim)
            else
                exit
            end
    end

    if test -n "$url"
        xdg-open "$url"
    end
end
