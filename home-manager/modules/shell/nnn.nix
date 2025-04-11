let
  fuck = ''$'';
in
  {pkgs, ...}: {
    xresources.properties = {
      "Nsxiv.window.background" = "#1e1e2e";
    };

    programs.nnn = {
      enable = true;
      # extraPackages = with pkgs; [file mktemp xdragon z-lua ffmpegthumbnailer ffmpeg glow bat atool eza unzip man ueberzugpp lynx imagemagick libreoffice poppler_utils less];
      extraPackages = with pkgs; [file mktemp xdragon mpv nsxiv zathura xdotool tabbed];
      package = pkgs.nnn.override {withNerdIcons = true;};
      bookmarks = {
        c = "~/";
        b = "~/Desktop/notes";
        n = "~/nix";
        d = "~/Downloads";
      };

      # NODE: разрабинье васяниус, поэтому качаем имеративно плагины

      # sh -c "$(curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs)"

      # TODO: сделать создание папок плагинов через home-manager

      # plugins = {
      #   src =
      #     pkgs.fetchFromGitHub {
      #       owner = "jarun";
      #       repo = "nnn";
      #       rev = "nnn v5.0 Daiquiri";
      #       sha256 = "sha256-Hpc8YaJeAzJoEi7aJ6DntH2VLkoR6ToP6tPYn3llR7k=";
      #     }
      #     + "/plugins";
      #   mappings = {
      #     # c = "fzcd";
      #     # f = "finder";
      #     # v = "imgview";
      #     # p = "preview-tui";
      #   };
      # };
    };
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    # home.file = {
    #   "/.config/nnn/plugins/nvim".text = ''
    #
    #     #!/usr/bin/env sh
    #
    #     # Description: cd to the top level of the current git repository in the current context
    #     # Dependencies: git
    #     # Shell: sh
    #     # Author: https://github.com/PatrickF1
    #
    #     root="$(git rev-parse --show-toplevel 2>/dev/null)"
    #     if [ -n "$root" ]; then
    #         printf "%s" "0c$root" > "$NNN_PIPE"
    #     else
    #         printf "Not in a git repository"
    #         read -r _
    #         exit 1
    #     fi
    #
    #     NUKE="${fuck}{XDG_CONFIG_HOME:-$HOME/.config}/nnn/plugins/nuke"
    #     USE_NUKE=0
    #
    #     # shellcheck disable=SC1090,SC1091
    #     . "$(dirname "$0")"/.nnn-plugin-helper
    #
    #     # Configure preview command
    #     preview_cmd='bat --color=always --style=numbers --line-range=:500 {}'
    #     preview_window='top:50%:border'
    #
    #     if type fzf >/dev/null 2>&1; then
    #         cmd="$FZF_DEFAULT_COMMAND"
    #         if type fd >/dev/null 2>&1; then
    #             [ -z "$cmd" ] && cmd="fd -t f 2>/dev/null"
    #         else
    #             [ -z "$cmd" ] && cmd="find . -type f 2>/dev/null"
    #         fi
    #         entry="$(eval "$cmd" | fzf -m \
    #             --preview "$preview_cmd" \
    #             --preview-window "$preview_window" \
    #             --bind 'ctrl-p:toggle-preview' \
    #             --cycle)"
    #     elif type sk >/dev/null 2>&1; then
    #         entry=$(find . -type f 2>/dev/null | sk)
    #     else
    #         exit 1
    #     fi
    #
    #     # Check for picker mode
    #     if [ "$3" ]; then
    #         if [ "$entry" ]; then
    #             case "$entry" in
    #                 /*) fullpath="$entry" ;;
    #                 *)  fullpath="$PWD/$entry" ;;
    #             esac
    #             if [ "-" = "$3" ]; then
    #                 printf "%s\n" "$fullpath"
    #             else
    #                 printf "%s\n" "$fullpath" >"$3"
    #             fi
    #
    #             # Tell `nnn` to clear its internal selection
    #             printf "%s" "0p" >"$NNN_PIPE"
    #         fi
    #
    #         exit 0
    #     fi
    #
    #     if [ "$entry" ]; then
    #         if [ "$USE_NUKE" -ne 0 ]; then
    #             "$NUKE" "$entry"
    #             exit 0
    #         fi
    #
    #         # Open the file (works for a single file only)
    #         cmd_file=""
    #         cmd_open=""
    #         if uname | grep -q "Darwin"; then
    #             cmd_file="file -bIL"
    #             cmd_open="open"
    #         else
    #             cmd_file="file -biL"
    #             cmd_open="xdg-open"
    #         fi
    #
    #         case "$($cmd_file "$entry")" in
    #             *text*)
    #                 "${fuck}{VISUAL:-$EDITOR}" "$entry"
    #                                               ;;
    #             *)
    #                 $cmd_open "$entry" >/dev/null 2>&1
    #                                                    ;;
    #         esac
    #     fi
    #   '';
    # };
  }
