function workdir
    set work_base ~/work
    set work_path (find "$work_base" -maxdepth 1 -type d -name "*$argv*" | head -n 1)
    if not test "$argv"; or not test "$work_path"
        set work_path "$work_base"
    end
    echo "$work_path"
end
