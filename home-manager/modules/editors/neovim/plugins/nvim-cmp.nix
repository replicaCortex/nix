{
  programs.nixvim = {
    plugins.cmp = {
      enable = true;

      settings = {
        # snippet = {
        #   expand = ''
        #     function(args)
        #       require('luasnip').lsp_expand(args.body)
        #     end
        #   '';
        # };

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

        sources = [
          {
            name = "luasnip";
          }
          {
            name = "vimtex";
          }
          {
            name = "nvim_lsp";
          }
          {
            name = "path";
          }
          {
            name = "buffer";
          }
        ];
      };
      cmdline = {
        # "/" = {
        #   mapping = {
        #     # __raw = "cmp.mapping.preset.cmdline()";
        # __raw = ''
        #   { ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "c" }),
        #     ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "c" }),
        #     ["<TAB>"] = cmp.mapping.confirm({ select = true }), }
        #     '';
        #   };
        #   sources = [
        #     {
        #       name = "buffer";
        #     }
        #   ];
        # };
        ":" = {
          mapping = {
            # __raw = "cmp.mapping.preset.cmdline()";
            __raw = ''
              { ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "c" }),
                ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "c" }),
                ["<TAB>"] = cmp.mapping.confirm({ select = true }), }
            '';
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
