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

    set -l url_encoded_rest (echo "$rest" | jq -sRr @uri)

    switch $cmd
        case go пщ
            set url "https://aistudio.google.com/prompts/new_chat"
        case nix тшч
            if test -n "$rest"
                set url "https://search.nixos.org/packages?channel=unstable&query=$url_encoded_rest"
            else
                set url "https://search.nixos.org/packages?channel=unstable"
            end
        case tr ек
            set url "https://translate.google.com/?hl=en&text=$url_encoded_rest"
        case ytr нек
            set url "https://translate.yandex.com/?source_lang=en&target_lang=ru&text=$url_encoded_rest"
        case an фт
            if test -n "$rest"
                set url "https://annas-archive.gl/search?q=$url_encoded_rest"
            else
                set url "https://annas-archive.gl/"
            end
        case img шьп
            set url "https://gelbooru.com/index.php?page=post&s=list&tags=all"
        case re ку
            if test -n "$rest"
                set url "https://old.reddit.com/search?q=$url_encoded_rest"
            else
                set url "https://old.reddit.com/"
            end
        case de ву
            set url "https://chat.deepseek.com/"
        case qw йц
            set url "https://chat.qwen.ai/"
        case dr вк
            set url "https://www.tldraw.com/"
        case du вг
            set url "https://duckduckgo.com/?q=DuckDuckGo+AI+Chat&ia=chat&duckai=1"
        case git пше
            if test -n "$rest"
                set url "https://github.com/search?q=$url_encoded_rest"
            else
                set url "https://github.com/"
            end
        case ng тп
            set url "https://www.newgrounds.com/"
        case 2ch 2ср
            set url "https://2ch.su/"
        case w ц
            set url "https://web.whatsapp.com/"
        case rev кум
            if test -n "$rest"
                set url "https://context.reverso.net/translation/english-russian/$url_encoded_rest"
            else
                set url "https://context.reverso.net/translation/english-russian/"
            end
        case sh ыр
            set url "https://npi-tu.ru/schedule/schedule.html?for=student&faculty=2&year=3&group=%D0%9F%D0%9E%D0%92%D0%B0"
        case wo цщ
            set url "https://docs.google.com/document/u/0/"
        case be иу
            set url "https://rostov-na-donu.beeline.ru/customers/products/elk/"
        case s ы
            set url "https://sdo.npi-tu.ru/"
        case sdo ывщ
            sdo
        case npi ывщ
            set url "https://dec.srspu.ru/Ved/"
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
        case arf фка
            set url "https://arena.ai/direct?m=flash"
        case helltaker
            niri_spawn_sh "$BROWSER https://www.youtube.com/playlist?list=PLzxkyQKtgmo9A0Gq-YS1vvxqlLNgB8vhU"

        case ah фр
            set -l db_path "$XDG_DATA_HOME/qutebrowser/webengine/Cookies"
            set -l temp_db (mktemp)

            cp "$db_path" "$temp_db"

            set -l query "SELECT name || '=' || value FROM cookies WHERE host_key LIKE '%arena.ai%' AND value != '';"

            set -l raw_cookies (sqlite3 "$temp_db" "$query")

            rm "$temp_db"

            set -l ARENA_COOKIE (string join "; " $raw_cookies)

            if test -z "$ARENA_COOKIE"
                echo "Ошибка: Куки для arena.ai не найдены."
                sleep 3
                exit
            end

            set -l ARENA_API "https://arena.ai/api/history/unified?limit=40&includeArchived=false"
            set -l raw_json (curl -s "$ARENA_API" -H "cookie: $ARENA_COOKIE")

            if echo "$raw_json" | grep -q Unauthorized
                echo "Error cookie"
                sleep 3
                exit
            end

            set -l selected (echo "$raw_json" | \
                             jq -r '.entries[] | "\(.title | gsub("\n"; " "))\t\(.id)"' | \
                             fzf --delimiter '\t' \
                                 --with-nth 1 \
                                 --header "Arena History" \
                                 --preview 'printf "\033[1;32mID:\033[0m %s\n\n\033[1;33mЗаголовок:\033[0m %s\n" "{2}" "{1}"' \
                                 --preview-window=top:40%:wrap)

            if test $status -eq 0; and test -n "$selected"
                set chat_id (echo "$selected" | cut -f2 | string trim)
                set url "https://arena.ai/c/$chat_id"
            else
                exit
            end

        case '*'
            set -l selected (ddgr -n 25 --noua --json --noprompt "$input_text" | \
                             jq -r '.[] | "\(.title)\t\(.url)\t\(.abstract)"' | \
                             fzf --delimiter '\t' \
                                 --with-nth 1 \
                                 --header "$input_text" \
                                 --preview 'printf "\033[1;32mURL:\033[0m %s\n\n\033[1;33mDescription:\033[0m %s\n" "{2}" "{3}"' \
                                 --preview-window=top:50%:wrap)

            if test $status -eq 0; and test -n "$selected"
                set url (echo "$selected" | cut -f2 | string trim)
            else
                exit
            end
    end

    if test -n "$url"
        niri_spawn_sh "$BROWSER \"$url\""
    end
end
