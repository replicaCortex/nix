function work
    set -l work_path (workdir $argv)
    echo "$work_path"
    cd "$work_path"
end
