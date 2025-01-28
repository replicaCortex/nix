{pkgs, ...}: {
  programs.nixvim = {
    plugins.blink-compat = {
      enable = true;
    };

    plugins.blink-cmp = {
      enable = true;
      settings = {
        appearance = {
          nerd_font_variant = "normal";
          use_nvim_cmp_as_default = true;
        };
        completion = {
          accept = {
            auto_brackets = {
              enabled = true;
              semantic_token_resolution = {
                enabled = false;
              };
            };
          };
          documentation = {
            auto_show = true;
          };
        };
        keymap = {
          preset = "super-tab";
        };
        signature = {
          enabled = true;
        };
        sources = {
          cmdline = [];
        };
        keymap = {
          "<C-b>" = [
            "scroll_documentation_up"
            "fallback"
          ];
          "<C-e>" = [
            "hide"
          ];
          "<C-f>" = [
            "scroll_documentation_down"
            "fallback"
          ];
          "<C-n>" = [
            "select_next"
            "fallback"
          ];
          "<C-[>" = [
            "select_prev"
            "fallback"
          ];
          "<K>" = [
            "show"
            "show_documentation"
            "hide_documentation"
          ];
          # "<A-CR>" = [
          #   "select_and_accept"
          # ];
          "<Down>" = [
            "select_next"
            "fallback"
          ];
          "<Up>" = [
            "select_prev"
            "fallback"
          ];
        };
        sources = {
          default = [
            "lsp"
            "path"
            "snippets"
            "buffer"
            "neorg"
          ];
          providers = {
            neorg = {
              name = "neorg";
              module = "blink.compat.source";
            };
          };
        };
      };
    };
  };
}
