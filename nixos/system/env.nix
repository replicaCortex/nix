{
  environment.sessionVariables = {
    # Path
    PATH = "$HOME/.var/.local/bin:$PATH";

    # XDG Base Directories
    XDG_CONFIG_HOME = "$HOME/.var/.config";
    XDG_DATA_HOME = "$HOME/.var/.local/share";
    XDG_STATE_HOME = "$HOME/.var/.local/state";
    XDG_CACHE_HOME = "$HOME/.var/.cache";

    # Specific programs
    HISTFILE = "$HOME/.var/.local/state/bash/history";
    WGETRC = "$HOME/.var/.config/wgetrc";
    INPUTRC = "$HOME/sys/nix/.inputrc";

    BROWSER = "zen";
    EDITOR = "nvim";
    TERMINAL = "foot";
    VISUAL = "nvim";

    # Nixpkgs
    NIXPKGS_ALLOW_UNFREE = "1";

    # Wayland/Graphics settings
    CLUTTER_BACKEND = "wayland";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    GDK_BACKEND = "wayland,x11,*";
    GDK_DPI_SCALE = "1";
    GDK_SCALE = "1";
    GSK_RENDERER = "ngl";
    GTK_USE_PORTAL = "1";

    # Qt settings
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_FFMPEG_DECODING_HW_DEVICE_TYPES = "vaapi";
    QT_FFMPEG_ENCODING_HW_DEVICE_TYPES = "vaapi";
    QT_MEDIA_BACKEND = "ffmpeg";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_QPA_PLATFORMTHEME = "xdgdesktopportal";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

    # SDL
    SDL_VIDEODRIVER = "wayland";

    # WLR (wlroots)
    WLR_NO_HARDWARE_CURSORS = "1";

    # X11
    DISPLAY = ":0";

    # Proxy
    PROXY = "https://openproxy:2ad5c3cece9f19f6@nl-hub.freeruproxy.ink:443";

    # Host-spawn
    XDG_RUNTIME_DIR = "/run/user/1000";
    DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/1000/bus";
  };
}
