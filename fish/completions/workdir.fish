for work in (find ~/work -maxdepth 1 -type d)
    complete -f -c workdir -a "(basename \"$work\")"
end
