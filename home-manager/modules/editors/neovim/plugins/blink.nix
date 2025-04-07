{
  programs.nixvim = {
    plugins.blink-compat = {
      enable = true;
    };

    plugins.blink-cmp = {
      enable = true;
      settings = {
        appearance = {
          nerd_font_variant = "normal";
          # use_nvim_cmp_as_default = true; # Используем поведение nvim-cmp по умолчанию
        };

        # completion = {
        #   accept = {
        #     auto_brackets = {
        #       enabled = true;
        #       semantic_token_resolution = {
        #         enabled = false;
        #       };
        #     };
        #   };
        #   trigger = {
        #     enable = true;
        #     show_on_trigger_character = true;
        #     show_on_keyword = true;
        #     completion.trigger.show_on_insert_on_trigger_character = true;
        #     show_on_accept_on_trigger_character = true;
        #   };
        #   completion.list.selection = {
        #     preselect = true;
        #     auto_insert = false;
        #   };
        #   documentation = {
        #     auto_show = true;
        #     auto_show_delay_ms = 500;
        #   };
        # };

        keymap = {
          "<C-n>" = ["select_next" "fallback"];
          "<C-p>" = ["select_prev" "fallback"];
          "<C-b>" = ["scroll_documentation_up" "fallback"];
          "<C-f>" = ["scroll_documentation_down" "fallback"];
          "<ESC>" = ["hide" "fallback"];
          # "<Esc>".__raw = ''
          #   cmp.mapping(function(fallback)
          #       if cmp.visible() then
          #         cmp.abort()
          #         fallback()
          #       else
          #         fallback()
          #       end
          #     end, {"i", "s"})
          # '';
          "<CR>" = ["accept" "fallback"];
        };

        signature = {
          enabled = true;
        };

        sources = {
          # cmdline = null;
          default = [
            "snippets"
            "vimtex"
            "lsp"
            "path"
            "buffer"
          ];
          providers = {
            vimtex = {
              name = "vimtex";
              module = "blink.compat.source";
            };
            tmux = {
              name = "tmux";
              module = "blink.compat.source";
            };
          };
        };
      };
    };
  };
}
