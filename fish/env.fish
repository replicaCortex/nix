set -gx BROWSER zen
set -gx EDITOR nvim
set -gx TERMINAL foot
set -gx VISUAL nvim
set -gx PROXY "https://openproxy:2ad5c3cece9f19f6@nl-hub.freeruproxy.ink:443"
set -gx NIXPKGS_ALLOW_UNFREE 1

set -gx CLUTTER_BACKEND wayland
set -gx ELECTRON_OZONE_PLATFORM_HINT auto
set -gx GDK_BACKEND "wayland,x11,*"
set -gx QT_QPA_PLATFORMTHEME xdgdesktopportal
set -gx GDK_DPI_SCALE 1
set -gx GDK_SCALE 1
set -gx GTK_USE_PORTAL 1
set -gx GSK_RENDERER ngl
set -gx QT_AUTO_SCREEN_SCALE_FACTOR 1
set -gx QT_QPA_PLATFORM "wayland;xcb"
set -gx QT_WAYLAND_DISABLE_WINDOWDECORATION 1
set -gx SDL_VIDEODRIVER wayland
set -gx WLR_NO_HARDWARE_CURSORS 1
set -gx QT_FFMPEG_DECODING_HW_DEVICE_TYPES vaapi
set -gx QT_FFMPEG_ENCODING_HW_DEVICE_TYPES vaapi
set -gx QT_MEDIA_BACKEND ffmpeg

fish_add_path ~/.cargo/bin
