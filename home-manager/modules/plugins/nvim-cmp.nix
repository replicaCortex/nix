{
  programs.nixvim = {
    # `friendly-snippets` contains a variety of premade snippets
    #    See the README about individual language/framework/plugin snippets:
    #    https://github.com/rafamadriz/friendly-snippets
    # https://nix-community.github.io/nixvim/plugins/friendly-snippets.html
    # plugins.friendly-snippets = {
    #   enable = true;
    # };

    # Autocompletion
    # See `:help cmp`
    # https://nix-community.github.io/nixvim/plugins/cmp/index.html

    # plugins.cmp-cmdline = {
    #   enable = true;
    # };

    plugins.cmp = {
      enable = true;

      settings = {
        snippet = {
          expand = ''
            function(args)
              require('luasnip').lsp_expand(args.body)
            end
          '';
        };

        completion = {
          completeopt = "menu,menuone,noinsert";
        };

        mapping = {
          "<C-n>" = "cmp.mapping.select_next_item()";
          "<C-p>" = "cmp.mapping.select_prev_item()";
          "<C-b>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<Esc>".__raw = ''
            cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.abort()
                fallback()
              else
                fallback()
              end
            end, {"i", "s"})
          '';
          "<CR>" = "cmp.mapping.confirm { select = true }";

          # "<Esc>" = "cmp.mapping.abort()";
          # "<Tab>" = "cmp.mapping.select_next_item()";
          # "<S-Tab>" = "cmp.mapping.select_prev_item()";
          # "<C-Space>" = "cmp.mapping.complete {}";
          # "<C-l>" = ''
          #   cmp.mapping(function()
          #     if luasnip.expand_or_locally_jumpable() then
          #       luasnip.expand_or_jump()
          #     end
          #   end, { 'i', 's' })
          # '';
          # "<C-h>" = ''
          #   cmp.mapping(function()
          #     if luasnip.locally_jumpable(-1) then
          #       luasnip.jump(-1)
          #     end
          #   end, { 'i', 's' })
          # '';
        };

        # Dependencies
        #
        # WARNING: If plugins.cmp.autoEnableSources Nixivm will automatically enable the
        # corresponding source plugins. This will work only when this option is set to a list.
        # If you use a raw lua string, you will need to explicitly enable the relevant source
        # plugins in your nixvim configuration.
        sources = [
          # Snippet Engine & its associated nvim-cmp source
          # https://nix-community.github.io/nixvim/plugins/luasnip/index.html
          {
            name = "luasnip";
          }
          {
            name = "neorg";
          }

          # {
          #   name = "cmp_zotcite";
          # }
          # {
          #   name = "cmp_vimtex";
          # }

          {
            name = "vimtex";
          }
          # Adds other completion capabilites.
          #  nvim-cmp does not ship with all sources by default. They are split
          #  into multiple repos for maintenance purposes.
          # https://nix-community.github.io/nixvim/plugins/cmp-nvim-lsp.html
          {
            name = "nvim_lsp";
          }
          # https://nix-community.github.io/nixvim/plugins/cmp-path.html
          {
            name = "path";
          }
        ];
      };
      cmdline = {
        "/" = {
          mapping = {
            __raw = "cmp.mapping.preset.cmdline()";
            # "<C-n>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            # "<C-p>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            # "<TAB>" = "cmp.mapping.confirm({ select = true })";
          };
          sources = [
            {
              name = "buffer";
            }
          ];
        };
        ":" = {
          mapping = {
            __raw = "cmp.mapping.preset.cmdline()";
            # "<C-n>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            # "<C-p>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            # "<TAB>" = "cmp.mapping.confirm({ select = true })";
          };
          sources = [
            {
              name = "path";
            }
            {
              name = "cmdline";
              option = {
                ignore_cmds = [
                  "Man"
                  "!"
                ];
              };
            }
          ];
        };
      };
    };
    extraConfigLuaPre = ''

      -- local cmp = require("cmp")
      --
      -- cmp.setup({
      --   mapping = {
      --     ["<C-n>"] = cmp.mapping.select_next_item(),
      --     ["<C-p>"] = cmp.mapping.select_prev_item(),
      --     ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      --     ["<C-f>"] = cmp.mapping.scroll_docs(4),
      --     ["<Esc>"] = cmp.mapping.abort()
      --     ["<CR>"] = cmp.mapping.confirm { select = true },
      --   }
      -- })

    '';
  };
}
