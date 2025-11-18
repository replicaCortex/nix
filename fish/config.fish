if status is-interactive
end

fish_vi_key_bindings

function sfrc --description "dotfile by replicaCortex"
    source ~/.config/fish/aliases.fish
    source ~/.config/fish/env.fish
    source ~/.config/fish/functions.fish
end

sfrc

direnv hook fish | source
any-nix-shell fish --info-right | source
