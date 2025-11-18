for work in (find ~/work -maxdepth 1 -type d)
    complete -f -c work -a "(basename \"$work\")"
end
