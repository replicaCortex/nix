function launch
    set -l input_text $argv
    set -l urls

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
            set urls "https://aistudio.google.com/prompts/new_chat"
        case nix тшч
            if test -n "$rest"
                set urls "https://search.nixos.org/packages?channel=unstable&query=$url_encoded_rest"
            else
                set urls "https://search.nixos.org/packages?channel=unstable"
            end
        case tr ек
            set urls "https://translate.google.com/?hl=en&text=$url_encoded_rest"
        case ytr нек
            set urls "https://translate.yandex.com/?source_lang=en&target_lang=ru&text=$url_encoded_rest"
        case an фт
            if test -n "$rest"
                set urls "https://annas-archive.gl/search?q=$url_encoded_rest"
            else
                set urls "https://annas-archive.gl/"
            end
        case img шьп
            set urls "https://gelbooru.com/index.php?page=post&s=list&tags=all"
        case re ку
            if test -n "$rest"
                set urls "https://old.reddit.com/search?q=$url_encoded_rest"
            else
                set urls "https://old.reddit.com/"
            end
        case de ву
            set urls "https://chat.deepseek.com/"
        case qw йц
            set urls "https://chat.qwen.ai/"
        case dr вк
            set urls "https://www.tldraw.com/"
        case du вг
            set urls "https://duckduckgo.com/?q=DuckDuckGo+AI+Chat&ia=chat&duckai=1"

        case git пше
            if test -n "$rest"
                set urls "https://github.com/search?q=$url_encoded_rest"
            else
                set urls "https://github.com/"
            end
        case ng тп
            set urls "https://www.newgrounds.com/"
        case 2ch 2ср
            set urls "https://2ch.su/"
        case w ц
            set urls "https://web.whatsapp.com/"
        case rev кум
            if test -n "$rest"
                set urls "https://context.reverso.net/translation/english-russian/$url_encoded_rest"
            else
                set urls "https://context.reverso.net/translation/english-russian/"
            end
        case sh ыр
            set urls "https://npi-tu.ru/schedule/schedule.html?for=student&faculty=2&year=3&group=%D0%9F%D0%9E%D0%92%D0%B0"
        case wo цщ
            set urls "https://docs.google.com/document/u/0/"
        case be иу
            set urls "https://rostov-na-donu.beeline.ru/customers/products/elk/"
        case s ы
            set urls "https://sdo.npi-tu.ru/"
        case sdo ывщ
            sdo
        case npi ывщ
            set urls "https://dec.srspu.ru/Ved/"
        case vk мл
            set urls "https://vk.com/im"
        case manga ьфтпф
            set urls "https://mangadex.org/titles/follows"
        case qp йз
            set urls "https://posemy.art/quick-poses/"
        case al фд
            set urls "https://alice.yandex.ru/"
        case yt фд
            set urls "https://www.youtube.com/feed/downloads"
        case ar фк
            set urls "https://arena.ai/?mode=direct"
        case arf фка
            set urls "https://arena.ai/direct?m=flash"
        case helltaker
            set urls "https://www.youtube.com/playlist?list=PLzxkyQKtgmo9A0Gq-YS1vvxqlLNgB8vhU"
        case van
            set urls "https://www.youtube.com/playlist?list=PL5pycTgSAvaB4EE1h_bZOQl2DHiHFy6_g"

        case ah фр
            set -l db_path "$XDG_DATA_HOME/qutebrowser/webengine/Cookies"
            set -l temp_db (mktemp)

            cp "$db_path" "$temp_db"

            set -l query "SELECT name || '=' || value FROM cookies WHERE host_key LIKE '%arena.ai%' AND value != '';"

            set -l raw_cookies (sqlite3 "$temp_db" "$query")

            rm "$temp_db"

            set -l ARENA_COOKIE (string join "; " $raw_cookies)

            if test -z "$ARENA_COOKIE"
                echo "Error cookie"
                sleep 3
                exit
            end

            set -l ARENA_API "https://arena.ai/api/history/unified?limit=50&includeArchived=false"
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
                                 --preview 'printf "\033[1;32mID:\033[0m %s\n\n\033[1;33mЗаголовок:\033[0m %s\n" "{2}" "{1}"' \
                                 --preview-window=top:50%:wrap)

            if test $status -eq 0; and test -n "$selected"
                for line in $selected
                    set -l chat_id (echo "$line" | cut -f2 | string trim)
                    set -a urls "https://arena.ai/c/$chat_id"
                end
            else
                exit
            end

        case '*'
            set -l selected (ddgr -n 25 --noua --json --noprompt "$input_text" | \
                             jq -r '.[] | "\(.title)\t\(.url)\t\(.abstract)"' | \
                             fzf --delimiter '\t' \
                                 --with-nth 1 \
                                 --preview 'printf "\033[1;32mURL:\033[0m %s\n\n\033[1;33mDescription:\033[0m %s\n" "{2}" "{3}"' \
                                 --preview-window=top:50%:wrap)

            if test $status -eq 0; and test -n "$selected"
                for line in $selected
                    set -a urls (echo "$line" | cut -f2 | string trim)
                end
            else
                exit
            end
    end

    if test -n "$urls"
        for url in $urls
            niri_spawn_sh "$BROWSER \"$url\""
        end
    end
end
