{pkgs, ...}: {
  home.file = {
    "/.config/nvim/templates/norg/journal.norg".text = ''
      @document.meta
      title: {TITLE_INPUT}
      description:
      authors: {AUTHOR}
      categories:
      created: {TODAY}
      updated: {TODAY}
      version: 1.0.0
      @end

      * {TITLE_INPUT}
        Weather: {WEATHER}
        {{:{YESTERDAY}:}}[Yesterday] - {{:{TOMORROW}:}}[Tomorrow]

      ** Daily Review
         - {CURSOR}
    '';
  };
  programs.nixvim = {
    plugins.neorg = {
      # lazyLoad.settings = {
      #   cmd = "Neorg";
      #   ft = "norg";
      # };
      enable = true;

      settings = {
        # lazy_loading = true;
        load = {
          "core.concealer" = {
            config = {
              icon_preset = "diamond";
              ordered_icons.__raw = ''
                {
                  ["1"] = function(i)
                    if i < 10 then
                      return "0" .. i
                    end
                    return tostring(i)
                  end;
                };

              '';

              icons = {
                todo = {
                  undone = {
                    icon = " ";
                  };
                };
                heading = {
                  icons = ["◆" "❖" "◈" "◇" "⟡" "⋄"];
                };
                delimiter = {
                  horizontal_line = {right = "textwidth";};
                };
                code_block = {
                  conceal = true;
                  spell_check = false;
                  content_only = false;
                  width = "content";
                  min_width = 85;
                  highlight = "CodeCell";
                };
              };
            };
          };
          "external.templates" = {
            templates_dir.__raw = ''vim.fn.stdpath("config") .. "/templates/norg";'';
            default_subcommand = "load";
            # keywords.__raw = ''
            #     {
            #     TODAY_TITLE = function()
            #       local buf = { vim.api.nvim_buf_get_name(0):match("(%d%d%d%d)/(%d%d)/(%d%d)%.norg$") }
            #       local date = os.date("%A %B %d, %Y", os.time({ year = buf[1], month = buf[2], day = buf[3] }))
            #       return require("luasnip").text_node(date)
            #     end,
            #     YESTERDAY_PATH = function()
            #       local buf = { vim.api.nvim_buf_get_name(0):match("(%d%d%d%d)/(%d%d)/(%d%d)%.norg$") }
            #       local time = os.time({ year = buf[1], month = buf[2], day = buf[3] })
            #       local yesterday = os.date("%Y/%m/%d", time - 86400)
            #       return require("luasnip").text_node(("../../%s"):format(yesterday))
            #     end,
            #     TOMORROW_PATH = function()
            #       local buf = { vim.api.nvim_buf_get_name(0):match("(%d%d%d%d)/(%d%d)/(%d%d)%.norg$") }
            #       local time = os.time({ year = buf[1], month = buf[2], day = buf[3] })
            #       local tomorrow = os.date("%Y/%m/%d", time + 86400)
            #       return require("luasnip").text_node(("../../%s"):format(tomorrow))
            #     end,
            #     CARRY_OVER_TODOS = function()
            #       -- local todos = table.concat(get_carryover_todos(), "\n")
            #       return require("luasnip").text_node(extras.get_carryover_todos())
            #     end,
            #     INSERT_2 = function()
            #       return require("luasnip").insert_node(1)
            #     end,
            #     INSERT_3 = function()
            #       return require("luasnip").insert_node(1)
            #     end,
            #     INSERT_4 = function()
            #       return require("luasnip").insert_node(1)
            #     end,
            #     WEATHER = function()
            #       local c = require("luasnip").choice_node
            #       local t = require("luasnip").text_node
            #       return c(1, { t("Sun"), t("Rain"), t("Storm"), t("Snow"), t("Clouds") })
            #     end,
            #   }
            # '';
          };

          "core.qol.toc" = {
            config = {
              enter = true;
              fixed_width = 26;
              auto_toc = {
                open = true;
                close = true;
                # exit = false;
              };
            };
          };
          "core.qol.todo_items" = {
            config = {
              # update_todo_parents = false;
            };
          };

          "core.keybinds" = {
            config = {
              default_keybinds = true;
            };
          };
          "core.summary" = {};

          "core.tangle" = {
            indent_errors = "print";
            report_on_empty = false;
          };
          # "core.latex.renderer" = {
          #   render = "core.integrations.image";
          #   conceal = true;
          # };
          # "core.looking-glass" = {};
          "core.defaults" = {
            __empty = null;
          };
          "core.dirman" = {
            config = {
              workspaces = {
                notes = ''~/Desktop/notes'';
              };
              default_workspace = "notes";
            };
          };
          "core.integrations.treesitter" = {};
          "core.journal" = {
            config = {
              journal_folder = "2_Live/journal";
              strategy = "flat";
              workspace = "notes";
              journals = {
              };
            };
          };
          "core.completion" = {
            config = {
              engine = {module_name = "external.lsp-completion";};
            };
          };

          "core.esupports.metagen" = {
            config = {
              undojoin_updates = true;
              type = "empty";
            };
          };

          "external.interim-ls" = {
            config = {
              completion_provider = {
                enable = true;
                # categories = true;
                # people = {enable = true;};
              };
            };
          };
        };
      };
      telescopeIntegration.enable = true;
    };
    # extraConfigLuaPre = ''
    #
    #   { "<leader>nn", "<Plug>(neorg.dirman.new-note)", desc = "New Note", silent = true },
    #
    # '';
    keymaps = [
      {
        mode = "n";
        key = "<localleader>i";
        action = ":Neorg index<CR>";
        options = {
          silent = true;
        };
      }

      {
        mode = "n";
        key = "<localleader>jy";
        action = ":Neorg journal yesterday<CR>";
        options = {
          silent = true;
        };
      }

      {
        mode = "n";
        key = "<localleader>jt";
        action = ":Neorg journal today<CR>";
        options = {
          silent = true;
        };
      }

      {
        mode = "n";
        key = "<localleader>jt";
        action = ":Neorg journal today<CR>";
        options = {
          silent = true;
        };
      }

      {
        mode = "n";
        key = "<localleader>;";
        action = "<Plug>(neorg.qol.todo-items.todo.task-cycle)";
        options = {
          silent = true;
        };
      }
    ];
  };
}
