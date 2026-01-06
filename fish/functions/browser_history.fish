function browser_history
    set -l ff_dir ~/.zen/*.Default\ Profile
    set -l db_path "$ff_dir/places.sqlite"
    set -l tmp_db "/tmp/ff_history_copy.sqlite"

    cp "$db_path" "$tmp_db"

    set -l query "SELECT title || ' ||| ' || url FROM moz_places WHERE title != '' ORDER BY last_visit_date DESC LIMIT 2000;"

    set -l selected (sqlite3 "$tmp_db" "$query" | fzf --reverse --query="$argv")

    if test -n "$selected"
        set -l parts (string split " ||| " $selected)
        set -l url $parts[-1]

        xdg-open "$url"
    end

    rm "$tmp_db"
end
