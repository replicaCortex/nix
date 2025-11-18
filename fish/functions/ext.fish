function ext
    argparse c/current h/help -- $argv
    or return 1

    if set -q _flag_h
        printf "Options:\n -c: Extract archive into current directory rather than a new one.\n"
        return 0
    end

    if test (count $argv) -eq 0
        printf "Give archive to extract as argument.\n"
        return 1
    end

    set -l file_arg $argv[1]
    set -l archive (readlink -f "$file_arg")

    if not test -f "$archive"
        printf "File \"%s\" not found.\n" "$archive"
        return 1
    end

    set -l original_dir $PWD

    if not set -q _flag_c
        set -l directory (string replace -r '\.[^/.]*$' '' $archive)

        mkdir -p "$directory"
        cd "$directory"
        or return 1
    end

    switch "$archive"
        case '*.tar.bz2' '*.tbz2'
            tar -xjf "$archive"
        case '*.tar.xz'
            tar -xJf "$archive"
        case '*.tar.gz' '*.tgz'
            tar -xzf "$archive"
        case '*.tar.zst'
            tar -I zstd -xf "$archive"
        case '*.tar'
            tar -xf "$archive"
        case '*.lzma'
            unlzma "$archive"
        case '*.bz2'
            bunzip2 "$archive"
        case '*.rar'
            unrar x -ad "$archive"
        case '*.gz'
            gunzip "$archive"
        case '*.zip'
            unzip "$archive"
        case '*.Z'
            uncompress "$archive"
        case '*.7z'
            7z x "$archive"
        case '*.xz'
            unxz "$archive"
        case '*.exe'
            cabextract "$archive"
        case '*'
            printf "extract: '%s' - unknown archive method\n" "$archive"
            if not set -q _flag_c
                cd $original_dir
            end
            return 1
    end

    if not set -q _flag_c
        cd $original_dir
    end
end
