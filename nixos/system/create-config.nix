let
  screenWidth = 1920;
  screenHeight = 1080;

  waybarWidth = 44;
  waybarHeight = 0;

  usableWidth = screenWidth - waybarWidth;
  usableHeight = screenHeight - waybarHeight;

  gaps = 16;
  winWidth = 500;
  winHeight = 450;

  x1 = gaps;
  y1 = gaps;

  x2 = gaps;
  y2 = usableHeight - winHeight - gaps;

  x3 = usableWidth - winWidth - gaps;
  y3 = gaps;

  x4 = usableWidth - winWidth - gaps;
  y4 = usableHeight - winHeight - gaps;

  x5 = (usableWidth / 2) - (winWidth / 2);
  y5 = (usableHeight / 2) - (winHeight / 2);

  browser = "qutebrowser";
  editor = "nvim";
  dotfiles = "$HOME/dev/nix";
  scripts = "${dotfiles}/terminal/scripts";
  smartFloatCmd = "${scripts}/smart-float.sh";
  withFocus = "${scripts}/with-focus.sh";
  nvimCallBack = "${scripts}/nvim-focus-callback.sh";
  tmsuDB = "$HOME/.tmsu/db";
  terminal = "foot";
  terminalClient = "footclient";

  wmSpawn = "niri msg action spawn-sh --";
  documentViewer = "zathura";
  videoViewer = "mpv";
  imageViewer = "timg";

  gb-bg0 = "#282828";
  gb-bg1 = "#3c3836";
  gb-bg2 = "#504945";
  gb-bg4 = "#7c6f64";
  gb-fg0 = "#fbf1c7";
  gb-fg1 = "#ebdbb2";
  gb-gray = "#928374";
  gb-gray-l = "#a89984";

  gb-red = "#cc241d";
  gb-green = "#98971a";
  gb-yellow = "#d79921";
  gb-blue = "#458588";
  gb-purple = "#b16286";
  gb-aqua = "#689d6a";
  gb-orange = "#d65d0e";
  gb-orange-l = "#fe88019";

  gb-red-l = "#fb4934";
  gb-green-l = "#b8bb26";
  gb-yellow-l = "#fabd2f";
  gb-blue-l = "#83a598";
in
{
  environment.sessionVariables = {
    PATH = "$HOME/.var/.local/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:/home/replica/.var/.dotnet/tools:$PATH:$HOME/.var/.cargo/bin/";

    SMART_FLOAT = smartFloatCmd;
    NVIM_CALL_BACK = nvimCallBack;
    WITH_FOCUS = withFocus;
    WM_SPAWN = wmSpawn;
    DOTFILES = dotfiles;
    SCRIPTS = scripts;
    TMSU_DB = tmsuDB;

    DOCUMENT_VIEWER = documentViewer;
    VIDEO_VIEWER = videoViewer;
    IMAGE_VIEWER = imageViewer;

    XDG_CONFIG_HOME = "$HOME/.var/.config";
    XDG_DATA_HOME = "$HOME/.var/.local/share";
    XDG_STATE_HOME = "$HOME/.var/.local/state";
    XDG_CACHE_HOME = "$HOME/.var/.cache";

    HISTFILE = "$HOME/.var/.local/state/bash/history";
    WGETRC = "$HOME/.var/.config/wgetrc";
    INPUTRC = "${dotfiles}/.inputrc";

    BROWSER = browser;
    EDITOR = editor;
    TERMINAL = terminalClient;
    VISUAL = editor;

    NIXPKGS_ALLOW_UNFREE = "1";

    CLUTTER_BACKEND = "wayland";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    GDK_BACKEND = "wayland,x11,*";
    GDK_DPI_SCALE = "1";
    GDK_SCALE = "1";
    GSK_RENDERER = "ngl";
    GTK_USE_PORTAL = "1";

    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_FFMPEG_DECODING_HW_DEVICE_TYPES = "vaapi";
    QT_FFMPEG_ENCODING_HW_DEVICE_TYPES = "vaapi";
    QT_MEDIA_BACKEND = "ffmpeg";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_QPA_PLATFORMTHEME = "xdgdesktopportal";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

    SDL_VIDEODRIVER = "wayland";
    WLR_NO_HARDWARE_CURSORS = "1";
    DISPLAY = ":0";

    PROXY = "https://openproxy:2ad5c3cece9f19f6@nl-hub.freeruproxy.ink:443";

    XDG_RUNTIME_DIR = "/run/user/1000";
    DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/1000/bus";

    ANDROID_HOME = "$HOME/Android/Sdk";
    DOTNET_ROOT = "/usr/share/dotnet";

    _JAVA_AWT_WM_NONREPARENTING = 1;
    UV_LINK_MODE = "copy";

    FZF_DEFAULT_OPTS =
      "--layout=reverse "
      + "--info=inline "
      + "--smart-case "
      + "--cycle "
      + "--ansi "
      + "--no-scrollbar "
      + "--multi "
      + "--with-shell='sh -c' "
      + "--bind=\"ctrl-f:preview-down,ctrl-b:preview-up\" "
      + "--color=\"fg:${gb-fg1},bg:${gb-bg0},hl:${gb-yellow-l},fg+:${gb-fg0},bg+:${gb-bg1},hl+:${gb-yellow}\" "
      + "--color=\"info:${gb-gray},prompt:${gb-yellow-l},pointer:${gb-yellow-l},marker:${gb-yellow-l},spinner:${gb-yellow-l},header:${gb-gray},border:#504945\"";
  };

  environment.etc."niri/config.kdl".text = ''
    input {
      workspace-auto-back-and-forth
      warp-mouse-to-focus mode="center-xy-always"
      keyboard {
        repeat-delay 500
        repeat-rate 25
        xkb {
          layout "us,ru"
          options "grp:caps_toggle,shift:both_capslock"
        }
        numlock
      }
      touchpad {
        tap
        dwt
        drag-lock
        accel-profile "adaptive"
        scroll-method "two-finger"
      }
    }

    cursor {
      hide-when-typing
      hide-after-inactive-ms 5000
    }

    output "eDP-1" {
      mode "${toString screenWidth}x${toString screenHeight}@120.030"
    }

    layout {
      gaps ${toString gaps}
      center-focused-column "always"
      background-color "transparent"
      empty-workspace-above-first

      preset-column-widths {
        proportion 0.45
        proportion 0.8
      }

      default-column-width { proportion 0.45; }

      focus-ring {
        width 2
        active-color "${gb-yellow}"
      }

      border {
        width 2
        active-color "${gb-yellow}"
        inactive-color "${gb-bg1}"
        urgent-color "${gb-red}"
      }

      tab-indicator {
        width 2
        gap 4
        gaps-between-tabs 2
        inactive-color "${gb-gray}"
      }
    }

    prefer-no-csd

    overview {
      backdrop-color "${gb-bg0}"
      workspace-shadow {
        color "#0007"
        offset x=0 y=10
        softness 50
        spread 20
      }
    }

    clipboard {
      disable-primary
    }

    spawn-sh-at-startup "${dotfiles}/terminal/scripts/init.sh"
    spawn-sh-at-startup "rm ~/ly-session.log"

    hotkey-overlay {
      skip-at-startup
    }

    screenshot-path null

    window-rule {
      match app-id="^float-[1-5]$"
      open-floating true
      default-column-width { fixed ${toString winWidth}; }
      default-window-height { fixed ${toString winHeight}; }

      border {
        width 2
        inactive-color "${gb-bg1}"
      }

      shadow { on; }
    }

    window-rule { match app-id="float-1"; default-floating-position x=${toString x1} y=${toString y1}; }
    window-rule { match app-id="float-2"; default-floating-position x=${toString x2} y=${toString y2}; }
    window-rule { match app-id="float-3"; default-floating-position x=${toString x3} y=${toString y3}; }
    window-rule { match app-id="float-4"; default-floating-position x=${toString x4} y=${toString y4}; }
    window-rule { match app-id="float-5"; default-floating-position x=${toString x5} y=${toString y5}; }

    window-rule {
        match app-id=r#"^org\.telegram\.desktop$"# title="^Media viewer$"
        open-fullscreen false
    }

    window-rule {
      match title="^fzf-preview$"
      open-focused false
    }

    layer-rule {
      match namespace="^wallpaper$"
      match namespace="swww-daemon"
      place-within-backdrop true
    }

    workspace "chat"
    workspace "main"
    workspace "dev"
    workspace "temp"

    binds {
      Mod+Return            { spawn "${terminalClient}"; }
      Mod+Shift+Ctrl+Return { spawn "${terminal}"; }
      
      Mod+F       { spawn-sh "${smartFloatCmd} fish -c 'source ${dotfiles}/terminal/fish/functions/launch.fish; launch'"; }
      Mod+Shift+F { spawn-sh "${smartFloatCmd} bash --noprofile --norc -c ${dotfiles}/terminal/scripts/pick.sh"; }
      Mod+B       { spawn-sh "${smartFloatCmd} fish -c 'source ${dotfiles}/terminal/fish/functions/browser_history.fish; browser_history'"; }
      Mod+Y { spawn-sh "bash --noprofile --norc -c ${dotfiles}/terminal/scripts/cliphist-pick.sh"; }
      Mod+E       { spawn-sh "${terminalClient} -e bash --noprofile --norc -c 'btop'"; }
      Mod+V { spawn-sh "${smartFloatCmd} -e bash --noprofile --norc -c ${dotfiles}/terminal/scripts/vidir-wrapped.sh"; }
      
      Mod+G       { spawn-sh "${browser}"; }
      Mod+X       { spawn-sh "Telegram"; }
      Mod+P       { screenshot; }
      Mod+Shift+P { screenshot-window; }

      Mod+O repeat=false { toggle-overview; }
      Mod+Q repeat=false { close-window; }

      Mod+H     { focus-column-left; }
      Mod+J     { focus-window-or-workspace-down; }
      Mod+K     { focus-window-or-workspace-up; }
      Mod+L     { focus-column-right; }

      Mod+A     { focus-column-left; }
      Mod+S     { focus-window-or-workspace-down; }
      Mod+W     { focus-window-or-workspace-up; }
      Mod+D     { focus-column-right; }

      Mod+Shift+H     { move-column-left; }
      Mod+Shift+J     { move-window-down-or-to-workspace-down; }
      Mod+Shift+K     { move-window-up-or-to-workspace-up; }
      Mod+Shift+L     { move-column-right; }

      Mod+Shift+A     { move-column-left; }
      Mod+Shift+S     { move-window-down-or-to-workspace-down; }
      Mod+Shift+W     { move-window-up-or-to-workspace-up; }
      Mod+Shift+D     { move-column-right; }

      Mod+Ctrl+Shift+J     { move-workspace-down; }
      Mod+Ctrl+Shift+K     { move-workspace-up; }
      Mod+Ctrl+Shift+S     { move-workspace-down; }
      Mod+Ctrl+Shift+W     { move-workspace-up; }

      Mod+Ctrl+H     { focus-column-first; }
      Mod+Ctrl+L     { focus-column-last; }
      Mod+Ctrl+Shift+H   { move-column-to-first; }
      Mod+Ctrl+Shift+L  { move-column-to-last; }

      Mod+Ctrl+A     { focus-column-first; }
      Mod+Ctrl+D     { focus-column-last; }
      Mod+Ctrl+Shift+A   { move-column-to-first; }
      Mod+Ctrl+Shift+D  { move-column-to-last; }

      Mod+1 { focus-workspace 1; }
      Mod+2 { focus-workspace 2; }
      Mod+3 { focus-workspace 3; }
      Mod+4 { focus-workspace 4; }
      Mod+5 { focus-workspace 5; }

      Mod+Shift+1 { move-column-to-workspace 1; }
      Mod+Shift+2 { move-column-to-workspace 2; }
      Mod+Shift+3 { move-column-to-workspace 3; }
      Mod+Shift+4 { move-column-to-workspace 4; }
      Mod+Shift+5 { move-column-to-workspace 5; }

      Mod+Comma  { consume-or-expel-window-left; }
      Mod+Period { consume-or-expel-window-right; }

      Mod+R          { switch-preset-column-width; }
      Mod+U          { maximize-column; }  
      Mod+Shift+U    { expand-column-to-available-width; }
      Mod+M          { fullscreen-window; }
      Mod+Z          { center-column; }
      Mod+Shift+Z    { center-visible-columns; }
      Mod+Minus      { set-column-width "-10%"; }
      Mod+Equal      { set-column-width "+10%"; }
      Mod+Alt+Minus  { set-window-height "-10%"; }
      Mod+Alt+Equal  { set-window-height "+10%"; }
      Mod+I          { toggle-window-floating; }
      Mod+Space      { switch-focus-between-floating-and-tiling; }
      Mod+C          { toggle-column-tabbed-display; }

      Mod+F4   allow-when-locked=true repeat=false { spawn-sh "brightnessctl  --class=backlight set 10%+"; }
      Mod+F5   allow-when-locked=true repeat=false { spawn-sh "brightnessctl  --class=backlight set 10%-"; }
    }
  '';

  environment.etc."dunst/dunstrc".text = ''
    [global]
        font = "Ubuntu Mono"
        allow_markup = yes
        format = "<b>%s</b>\n%b"
        sort = yes
        indicate_hidden = yes
        alignment = center
        bounce_freq = 0
        show_age_threshold = 60
        word_wrap = yes
        ignore_newline = no
        geometry = "${toString ((winWidth * 1) / 4)}x5"
        transparency = 0
        idle_threshold = 120
        monitor = 0
        follow = mouse
        sticky_history = yes
        line_height = 0
        origin = top-center
        offset = 0x${toString gaps}
        
        separator_height = 2
        padding = 12
        horizontal_padding = 12
        frame_width = 2

        separator_color = "${gb-bg2}" 

        startup_notification = false

    [urgency_low]
        background = "${gb-bg0}"
        foreground = "${gb-gray-l}"
        frame_color = "${gb-gray-l}"
        timeout = 5

    [urgency_normal]
        background = "${gb-bg0}"
        foreground = "${gb-fg1}"
        frame_color = "${gb-yellow}"
        timeout = 10

    [urgency_critical]
        background = "${gb-bg0}"
        foreground = "${gb-fg1}"
        frame_color = "${gb-red-l}"
        timeout = 0
  '';
}
