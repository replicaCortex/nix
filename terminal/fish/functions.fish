function killprocess --description 'Kill process that user selects in fzf (from ps aux output)'
    set -l pid (ps aux | fzf -m --header-lines=1 | awk '{print $2}')

    if test -n "$pid"
        echo "Killing processes: $pid"
        kill -9 $pid
    end
end

function killport --description 'Select a port to kill, by pid, port, or command line'

    # Function to get the command line for a given PID
    function get_command -a pid
        ps -p $pid | awk 'NR>1 {for (i=4; i<=NF; i++) {printf "%s ", $i}; print ""}'
    end

    # Find listening processes, get commands, and format output
    lsof -iTCP -sTCP:LISTEN -P | awk '{print $2, $9}' | uniq | tail -n +2 | while read -l pid port
        set -l command (get_command $pid)
        set -l port (string pad -w 8 (string replace 'localhost' '' $port))
        set -l pid (string pad --right -w 6 $pid)
        echo -e "$pid $port $command" | column
    end |
        # Pipe the output to fzf for selection. Grab pid and show pstree
        fzf --exact --tac --preview 'pstree -p (echo {} | awk "{print $2}")' --preview-window=down,30% --header "Select a process to kill (PID Command Port):" |
        # Kill the selected process
        awk '{print $1}' | xargs -r kill -9
end

function clone --description "clone something, cd into it. install it."
    git clone --depth=1 $argv[1]
    cd (basename $argv[1] | sed 's/.git$//')
end

function md --wraps mkdir -d "Create a directory and cd into it"
    command mkdir -p $argv
    if test $status = 0
        switch $argv[(count $argv)]
            case '-*'
            case '*'
                cd $argv[(count $argv)]
                return
        end
    end
end

function fns --description "Interactively search/preview fish shell functions and aliases"
    set -l items

    #  Gather up all functions w/ descriptions
    for fn_name in (functions -n)
        set -l description ""
        # Get the full function definition output
        set -l definition_output (functions $fn_name | string collect) # Collect lines for easier matching

        # extract the description, unless its a wrap fn (alias)
        if not string match --quiet -- "--wraps*" "$definition_output"
            string match --quiet --regex -- '--description\s+(?<desc>[^$^\n]*)' "$definition_output"
        end

        if test -n "$desc"
            set -a items "$fn_name — $desc"
        else
            set -a items "$fn_name "
        end
    end

    set -l preview_cmd "
        set -l line {}
        set -l parts (string split ' — ' \"\$line\")
        set -l item_name (string trim \$parts[1])
        functions \"\$item_name\" | bat --color=always --plain --language=fish --line-range :500
    "

    set -l chosen_fn (printf "%s\n" $items | fzf \
        --height 60% \
        --ansi \
        --color="hl:#5f87af,hl+:#5fd7ff" \
        --layout reverse \
        --border rounded \
        --header 'fish functions' \
        --preview "$preview_cmd" \
        --preview-window 'right:60%:wrap')

    # on selection, output it.
    if test -n "$chosen_fn"
        set -l parts (string split ' — ' "$chosen_fn" \ )
        set -l item_name (string trim $parts[1])
        functions "$item_name" | bat --color=always --plain --language=fish --line-range :500
    end
end
