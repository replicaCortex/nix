#!/usr/bin/env fish

set -l current_layout (niri msg -j keyboard-layouts | jq '.current_idx')

if test "$current_layout" = 1
    niri msg action switch-layout next
end

br --conf "$XDG_CONFIG_HOME/broot/fast_open.hjson;$XDG_CONFIG_HOME/broot/conf.hjson"

# if test "$current_layout" = 1
#     niri msg action switch-layout next
# end
