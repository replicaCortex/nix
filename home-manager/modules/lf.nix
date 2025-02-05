let
  fuck = ''$'';
in {
  programs.pistol = {
    enable = true;
  };
  programs.lf = {
    enable = true;
    extraConfig = ''
      set previewer ~/.config/lf/previewer
      set cleaner ~/.config/lf/cleaner
    '';
  };
  home.file = {
    "~/.config/lf/previewer".text = ''
      #!/bin/sh
      draw() {
        kitten icat --stdin no --transfer-mode file --place "${fuck}{w}x${fuck}{h}@${fuck}{x}x${fuck}{y}" "$1" </dev/null >/dev/tty
        exit 1
      }

      file="$1"
      w="$2"
      h="$3"
      x="$4"
      y="$5"

      case "$(file -Lb --mime-type "$file")" in
        image/*)
          draw "$file"
          ;;
        video/*)
          # vidthumb is from here:
          # https://raw.githubusercontent.com/duganchen/kitty-pistol-previewer/main/vidthumb
          draw "$(vidthumb "$file")"
          ;;
      esac

      pistol "$file"
    '';
  };

  home.file = {
    "~/.config/lf/clenner".text = ''
      #!/bin/sh
      exec kitten icat --clear --stdin no --transfer-mode file </dev/null >/dev/tty
    '';
  };
}
