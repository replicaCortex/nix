let
  fuck = ''$'';
in
  {pkgs, ...}: {
    programs.nnn = {
      enable = true;
      extraPackages = with pkgs; [nsxiv file mktemp xdragon];
      package = pkgs.nnn.override {withNerdIcons = true;};
      bookmarks = {
        c = "~/";
        b = "~/Desktop/notes";
        n = "~/nix";
        d = "~/Downloads";
      };

      # NODE: разрабинье васяниус, поэтому качаем имеративно плагины

      # sh -c "$(curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs)"

      # :TODO сделать создание папок плагинов через home-manager

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
    };
  }
