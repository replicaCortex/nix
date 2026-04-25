function browser_history
    set -l ff_dir $HOME/.var/.local/share/qutebrowser
    set -l db_path $ff_dir/history.sqlite

    # Используем DISTINCT и группируем по URL, берем последнее время
    set -l query "SELECT url, title, MAX(atime) as last_time 
                  FROM History 
                  GROUP BY url 
                  ORDER BY last_time DESC 
                  LIMIT 20000;"

    set -l selected (sqlite3 "$db_path" "$query" | rg -v blank | fzf --reverse --query="$argv" --with-nth=2,1)

    if test -n "$selected"
        set -l parts (string split "|" $selected)
        set -l url $parts[1]

        niri msg action spawn-sh -- "$BROWSER \"$url\""
    end
end
