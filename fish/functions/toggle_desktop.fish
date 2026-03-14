function toggle_desktop
    set -l user $USER

    if string match -q "*niri*" "$XDG_CURRENT_DESKTOP"
        echo "Текущая среда: Niri. Переключаемся на GNOME..."

        sudo sed -i 's/^Session=.*/Session=gnome/' "/var/lib/AccountsService/users/$user"

        niri msg action quit

    else if string match -q "*GNOME*" "$XDG_CURRENT_DESKTOP"; or string match -q "*gnome*" "$XDG_CURRENT_DESKTOP"
        echo "Текущая среда: GNOME. Переключаемся на Niri..."

        sudo sed -i 's/^Session=.*/Session=niri/' "/var/lib/AccountsService/users/$user"

        gnome-session-quit --force --no-prompt

    else
        echo "Не удалось определить текущую среду: $XDG_CURRENT_DESKTOP"
        return 1
    end
end
