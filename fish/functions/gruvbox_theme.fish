function gruvbox_theme --description "Apply gruvbox color scheme to fish prompt"
    # Gruvbox color definitions
    set -g gruvbox_green (set_color 98971a)  # #98971a
    set -g gruvbox_blue (set_color 458588)   # #458588
    set -g gruvbox_red (set_color cc241d)    # #cc241d
    set -g gruvbox_yellow (set_color d79921) # #d79921
    set -g gruvbox_aqua (set_color 689d6a)   # #689d6a
    set -g gruvbox_orange (set_color d65d0e) # #d65d0e
    set -g gruvbox_purple (set_color b16286) # #b16286
    set -g gruvbox_gray (set_color a89984)   # #a89984
    set -g gruvbox_normal (set_color normal)
    
    # Apply colors to Hydro prompt
    set -g hydro_color_pwd $gruvbox_green
    set -g hydro_color_git $gruvbox_blue
    set -g hydro_color_error $gruvbox_red
    set -g hydro_color_prompt $gruvbox_yellow
    set -g hydro_color_duration $gruvbox_gray
    set -g hydro_color_start $gruvbox_aqua
    
    # Apply to git prompt as well
    set -g __fish_git_prompt_color_branch $gruvbox_blue
    set -g __fish_git_prompt_color_dirtystate $gruvbox_orange
    set -g __fish_git_prompt_color_upstream $gruvbox_purple
    
    echo "Gruvbox theme applied to Hydro prompt"
end