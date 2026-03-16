if status is-interactive
end

fish_vi_key_bindings

function sfrc --description "dotfile by replicaCortex"
    source $XDG_CONFIG_HOME/fish/aliases.fish
    source $XDG_CONFIG_HOME/fish/functions.fish
end

sfrc

# direnv hook fish | source
