let
  fuck = "$";
in {
  services.polybar = {
    enable = true;
    script = ''
      killall -q polybar
      while pgrep -u "$UID" -x polybar >/dev/null; do sleep 1; done

      DIR="$HOME/.config/polybar"

      polybar -q bar1 -c "$DIR/config.ini" &
      polybar -q bar2 -c "$DIR/config.ini" &
      polybar -q bar3 -c "$DIR/config.ini" &
    '';
    extraConfig = ''
      [global/wm]
      margin-top    = 0
      margin-bottom = -18
      include-file = ~/nix/static/polybar/colors.ini
      include-file = ~/nix/static/polybar/modules.ini


      [settings]
      screenchange-reload = true
      pseudo-transparency = true

      [bar/bar1]
      width = 12.30%
      height = 18pt
      radius = 0
      bottom = false
      # fixed-center = true

      background = ${fuck}{colors.base}
      # background = #00000000
      foreground = ${fuck}{colors.text}

      line-size = 0pt

      padding-left = 0
      padding-right = 0

      offset-x = 9
      offset-y = 5

      padding       = 2
      module-margin = 0

      border-size = 2pt
      border-color = ${fuck}{colors.surface0}

      font-0 = Ubuntu Mono:style=Regular:pixelsize=12;2

      # modules-left = xworkspaces
      # modules-center = dateH | dateW dot dateM | dateY
      # modules-right = ethernet xkeyboard alsa memory cpu

      modules-center = xworkspaces

      cursor-click = pointer
      cursor-scroll = ns-resize

      enable-ipc = true
      wm-restack = bspwm


      [bar/bar2]
      width = 14.8%
      height = 18pt
      radius = 0
      bottom = false
      # fixed-center = true

      background = ${fuck}{colors.base}
      # background = #00000000
      foreground = ${fuck}{colors.text}

      line-size = 0pt

      padding-left = 0
      padding-right = 0

      offset-x = 43.0%
      offset-y = 5

      padding       = 2
      module-margin = 0

      border-size = 2pt
      border-color = ${fuck}{colors.surface0}

      font-0 = Ubuntu Mono:style=Regular:pixelsize=12;2

      modules-center = dateH | dateW dot dateM | dateY

      cursor-click = pointer
      cursor-scroll = ns-resize

      enable-ipc = true
      wm-restack = bspwm

      [bar/bar3]
      width = 17.9%
      height = 18pt
      radius = 0
      bottom = false
      # fixed-center = true

      background = ${fuck}{colors.base}
      # background = #00000000
      foreground = ${fuck}{colors.text}

      line-size = 0pt

      padding-left = 0
      padding-right = 0

      offset-x = 81.63%
      offset-y = 5

      padding       = 2
      module-margin = 0

      border-size = 2pt
      border-color = ${fuck}{colors.surface0}

      font-0 = Ubuntu Mono:style=Regular:pixelsize=12;2

      # modules-center = dateH | dateW dot dateM | dateY
      modules-center = xkeyboard alsa memory cpu

      cursor-click = pointer
      cursor-scroll = ns-resize

      enable-ipc = true
      wm-restack = bspwm

      # [bar/bar2]
      # width = 17%
      # height = 18pt
      # radius = 0
      # bottom = false
      # fixed-center = true
      #
      # background = ${fuck}{colors.base}
      # # background = #00000000
      # foreground = ${fuck}{colors.text}
      #
      # line-size = 0pt
      #
      # padding-left = 0
      # padding-right = 0
      #
      # offset-x = 10
      # offset-y = 5
      #
      # padding       = 2
      # module-margin = 0
      #
      # border-size = 2pt
      # border-color = ${fuck}{colors.surface0}
      #
      # font-0 = Ubuntu Mono:style=Regular:pixelsize=12;2
      #
      # # modules-left = sep cpu sep memory sep gpu-temp sepmini sepmini alsa
      # # modules-center = xworkspaces
      # # modules-right = ethernet slesh sepmini xkeyboard slesh popup-calendar sep
      # # modules-right = ethernet slesh sepmini xkeyboard slesh date sep
      #
      # modules-left = xworkspaces
      # modules-center = dateH | dateW dot dateM | dateY
      # modules-right = ethernet xkeyboard alsa memory cpu
      #
      # # dpi-x = 96
      # # dpi-y = 96
      #
      # cursor-click = pointer
      # cursor-scroll = ns-resize
      #
      # enable-ipc = true
      # wm-restack = bspwm
      #
      # # tray-position = center
      # # tray-background = ${fuck}{colors.base}
      # # tray-offset-x = 124pt
      # # tray-padding = 5
      #
      #
    '';
  };
}
