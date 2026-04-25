function sdo
    echo "link | opp | web | sig"
    if test -z "$input_text"
        read -P (set_color green)"Search: "(set_color normal) -l user_input
        if test -z "$user_input"
            exit
        end
        set input $user_input
    end

    switch $input
        case link
            set url "https://sdo.npi-tu.ru/course/view.php?id=2135"
        case opp
            set url "https://sdo.npi-tu.ru/course/view.php?id=4972"
        case web
            set url "https://sdo.npi-tu.ru/course/view.php?id=4832"
        case sig
            set url "https://sdo.npi-tu.ru/course/view.php?id=4924"
    end

    if test -n "$url"
        niri_spawn_sh "$BROWSER \"$url\""
    end
end
