if status is-interactive

    function sfrc --description "dotfile by replicaCortex"
        source $XDG_CONFIG_HOME/fish/aliases.fish
        source $XDG_CONFIG_HOME/fish/functions.fish
    end

    sfrc
    # direnv hook fish | source
end

fish_vi_key_bindings

