{
  services.sxhkd = {
    enable = true;
    keybindings = {
      #"super + d" = "rofi -show drun -config .config/rofi/menu_bottom.rasi -show-icons";
      "super + d" = "dmenu_run";

      "super + {_,shift + }Return" = "{alacritty , bspc node -s biggest.local}";

      "@Print" = "scrot";

      "shift + @Print" = "scrot -d 5";

      "super + n" = "nemo";

      "super + o" = "obsidian";

      "super + w" = "firefox";

      "super + p" = "xcolor -P 150 -s clipboard";
      "Print" = "flameshot gui";

      # ПЕРЕЗАГРУЗИТЬ КОНФИГ SXHKD
      "super + e" = "pkill -USR1 -x sxhkd";

      # ВЫЙТИ/ПЕРЕЗАГРУЗИТЬ BSPWM
      "super + shift + {q,r}" = "bspc {quit,wm -r}";

      # ПЕРЕЗАГРУЗКА
      "super + ctrl + r" = "reboot";

      # ВЫКЛЮЧЕНИЕ
      "super + ctrl + p" = "poweroff";

      # ПОМЕНЯТЬ СТАТУС ОКНА
      "super + {t,shift + t,s,f}" = ''
        bspc node -t {tiled,pseudo_tiled,floating,fullscreen}
        bspc node -g {marked,locked,sticky,private}
      '';

      # ВЫБРАТЬ НАПРАВЛЕНИЕ НОВОГО ОКНА
      "super + alt + {h,j,k,l}" = "bspc node -p {west,south,north,east}";

      # ОТМЕНИТЬ НАПРАВЛЕНИЕ НОВОГО ОКНА
      "super + alt + space" = "bspc node -p cancel";

      # ПЕРЕКЛЮЧИТЬСЯ НА ВОРКСПЕЙС ИЛИ ПЕРЕТАЩИТЬ ОКНО
      "super + {_,shift + }{1-9,0}" = "bspc {desktop -f,node -d} '^{1-9,10}'";

      # ЗАКРЫТЬ ОКНО ИЛИ УБИТЬ ЕГО
      "super + {_, shift + }c" = "bspc node -{c}";

      # ПЕРЕМЕЩЕНИЕ ТАЙЛИНГОВЫХ ОКОН
      "super + {_,shift + }{h,j,k,l}" = "bspc node -{f,s} {west,south,north,east}";

      # РЕСАЙЗ ТАЙЛИНГОВЫХ ОКОН
      "super + ctrl + h" = ''
        bspc node -z {left -20 0}; bspc node -z {right -20 0}
      '';

      "super + ctrl + j" = ''
        bspc node -z {bottom 0 20}; bspc node -z {top 0 20}
      '';

      "super + ctrl + k" = ''
        bspc node -z {bottom 0 -20}; bspc node -z {top 0 -20}
      '';

      "super + ctrl + l" = ''
        bspc node -z {left 20 0}; bspc node -z {right 20 0}
      '';

      # РЕСАЙЗ ПЛАВАЮЩИХ ОКОН
      "alt + ctrl + {h,j,k,l}" = ''
        {bspc node -z right -20 20, \
        bspc node -z bottom 20 20, \
        bspc node -z bottom 20 -20, \
        bspc node -z right 20 20}
      '';

      # ПЕРЕМЕЩЕНИЕ ПЛАВАЮЩИХ ОКОН
      "ctrl + shift + {h,j,k,l}" = "bspc node -v {-20 0,0 20,0 -20,20 0}";
    };
  };
}
