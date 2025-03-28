{
  programs.nixvim = {
    # TODO: убрать черный фон для документации от темы
    plugins.cmp = {
      autoEnableSources = true;
      enable = true;

      settings = {
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
          {
            name = "tmux";
          }
        ];
      };

      cmdline = {
        ":" = {
          mapping = {
            __raw = ''
              {
                ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "c" }),
                ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "c" }),
                ["<Tab>"] = {
                c = function(default)
                    if cmp.visible() then
                      return cmp.confirm({ select = true })
                    end
                  default()
                end,},
              }
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

      local cmp = require'cmp'

      cmp.setup({
        formatting = {
        window = {
            completion = {
              border = "rounded",
            },
            documentation = {
              border = "rounded",
            }
          },
          format = function(entry, vim_item)
            local icons = {
              Class = " ",
              Color = " ",
              Constant = " ",
              Constructor = " ",
              Enum = " ",
              EnumMember = " ",
              Field = "󰄶 ",
              File = " ",
              Folder = " ",
              Function = "ƒ ",
              Interface = "󰜰 ",
              Keyword = "󰌆 ",
              Method = "󰡱 ",
              Module = "󰏗 ",
              Property = " ",
              Snippet = "󰘍 ",
              Struct = " ",
              Text = " ",
              Unit = " ",
              Value = "󰎠 ",
              Variable = "󰫧 ",
            }

            vim_item.kind = icons[vim_item.kind] or vim_item.kind
            return vim_item
          end
        }
      })

    '';
  };
}
