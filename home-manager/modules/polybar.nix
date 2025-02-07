let
  fuck = "$";
in {
  services.polybar = {
    enable = true;
    script = "polybar bar &";
    extraConfig = ''

      include-file = ~/nix/home-manager/modules/conf/polybar/colors.ini
      include-file = ~/nix/home-manager/modules/conf/polybar/modules.ini

      [bar/example]
      width = 1900
      height = 16pt
      radius = 0
      bottom = false

      background = ${fuck}{colors.bg}
      foreground = ${fuck}{colors.fg}

      line-size = 0pt

      padding-left = 0
      padding-right = 0

      module-margin = 0
      offset-x = 10
      offset-y = 10

      border-size = 4pt
      border-color = ${fuck}{colors.bg}

      font-0 = ProggyClean NerdFont:style=Regular:pixelsize=14;2
      font-1 = ProggyClean NerdFont:style=Regular:pixelsize=14;2
      font-2 = ProggyClean NerdFont:style=Regular:pixelsize=14;2
      font-3 = ProggyClean NerdFont:style=Regular:pixelsize=14;2

      modules-left = sep cpu sep memory sep alsa
      modules-center = xworkspaces
      modules-right = ethernet sepmini xkeyboard date sep

      dpi-x = 96
      dpi-y = 96

      cursor-click = pointer
      cursor-scroll = ns-resize

      enable-ipc = true
      wm-restack = bspwm


      tray-position = center
      tray-background = ${fuck}{colors.bg}
      tray-offset-x = 124pt
      tray-padding = 5


      [settings]
      screenchange-reload = true
      pseudo-transparency = true

    '';
  };
}
