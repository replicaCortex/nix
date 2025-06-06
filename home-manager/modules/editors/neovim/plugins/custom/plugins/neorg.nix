{
  home.file = {
    "/.config/nvim/templates/norg/journal.norg".text = ''
      @document.meta
      title: {TITLE_INPUT}
      authors: {AUTHOR}
      created: {TODAY}
      updated: {TODAY}
      version: 1.0.0
      @end

      * {TITLE_INPUT}
        TODO:
        ___
        ~ ( ) философия
        ~ ( ) lem
        ~ ( ) {CURSOR}

      ** Daily Review
         Reflections:

    '';
  };
  programs.nixvim = {
    plugins.neorg = {
      enable = true;

      settings = {
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
                  uncertain = {
                    icon = "?";
                  };
                  urgent = {
                    icon = "!";
                  };
                  pending = {
                    icon = "~";
                  };
                  cancelled = {
                    icon = "×";
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
            default_subcommand = "add";
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

          # "core.qol.toc" = {
          #   config = {
          #     enter = true;
          #     fixed_width = 26;
          #     auto_toc = {
          #       open = true;
          #       close = false;
          #       exit = false;
          #     };
          #   };
          # };
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
                notes = ''~/notes'';
              };
              default_workspace = "notes";
            };
          };
          "core.integrations.treesitter" = {};
          # "core.export.markdown" = {__empty = null;};
          "core.export" = {__empty = null;};
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
      telescopeIntegration.enable = false;
      telescopeIntegration.package = null;
    };
    # extraConfigLuaPre = ''
    #
    #   { "<leader>nn", "<Plug>(neorg.dirman.new-note)", desc = "New Note", silent = true },
    #
    # '';
    keymaps = [
      {
        mode = "n";
        key = "<localleader>ii";
        action = ":Neorg index<CR>";
        options = {
          silent = true;
        };
      }

      # {
      #   mode = "n";
      #   key = "<localleader>jy";
      #   action = ":Neorg journal yesterday<CR>";
      #   options = {
      #     silent = true;
      #   };
      # }
      #
      # {
      #   mode = "n";
      #   key = "<localleader>jo";
      #   action = ":Neorg journal tomorrow<CR>";
      #   options = {
      #     silent = true;
      #   };
      # }

      {
        mode = "n";
        key = "<localleader>;";
        action = "<Plug>(neorg.qol.todo-items.todo.task-cycle)";
        options = {
          silent = true;
        };
      }

      {
        mode = "n";
        key = "<localleader>TT";
        action = "<cmd>Neorg templates add journal<CR>";
        options = {
          silent = true;
        };
      }

      {
        mode = "n";
        key = "<localleader>jc";
        action = "<cmd>Neorg journal custom<CR>";
        options = {
          silent = true;
        };
      }
    ];

    autoCmd = [
      # {
      #   event = ["FileType"];
      #   pattern = "norg";
      #   callback.__raw = ''
      #     function()
      #       -- vim.api.nvim_buf_set_keymap(0, "n", "<localleader>fn", ":Telescope neorg find_norg_files<CR>", { noremap = true, silent = true })
      #       -- vim.api.nvim_buf_set_keymap(0, "n", "<localleader>nr", ":Neorg return<CR>", { noremap = true, silent = true })
      #       -- vim.api.nvim_buf_set_keymap(0, "n", "<localleader>il", ":Telescope neorg insert_link<CR>", { noremap = true, silent = true })
      #       -- vim.api.nvim_buf_set_keymap(0, "n", "<A-o>", ":Neorg toc left<CR>:q<CR>:bdelete<CR>", { noremap = true, silent = true })
      #       -- vim.api.nvim_buf_set_keymap(0, "n", "<C-C>", "<C-h>:q<CR>:bdelete!<CR>", { noremap = true, silent = true })
      #     end
      #   '';
      # }
      {
        event = ["BufWritePost"];
        pattern = "*.norg";
        callback.__raw = ''
          function()
            local view = vim.fn.winsaveview()
            vim.cmd("normal! gg=G")
            vim.fn.winrestview(view)
          end
        '';
      }

      # {
      #   event = ["FileType"];
      #   pattern = ["markdown" "norg"];
      #   callback.__raw = ''
      #     function()
      #     require("image").setup = image_setup_original
      #     require("image").setup(_M.image_config)
      #     end
      #   '';
      # }
      # {
      #   event = ["BufWritePost"];
      #   pattern = "*.norg";
      #   callback.__raw = ''
      #     function()
      #       vim.highlight.on_yank()
      #     end
      #   '';
      # }
    ];
    extraConfigLuaPre = ''
      -- vim.api.nvim_create_autocmd("FileType", {
      --     pattern = "*[0-9]*norg",
      --     callback = function()
      --         local stackoverflow = "~/Desktop/notes/2_Live/journal/stackoverflow.norg"
      --         local original_win = vim.api.nvim_get_current_win()
      --         local width = math.floor(vim.o.columns * 0.2)
      --         vim.cmd("vsplit" .. stackoverflow)
      --         vim.cmd("vertical resize " .. width)
      --         vim.api.nvim_set_current_win(original_win)
      --     end
      -- })

      -- vim.api.nvim_create_autocmd("BufLeave", {
      --     pattern = "norg",
      --     callback = function()
      --         for _, win in ipairs(vim.api.nvim_list_wins()) do
      --             local buf = vim.api.nvim_win_get_buf(win)
      --             local bufname = vim.api.nvim_buf_get_name(buf)
      --             if bufname:find("stackoverflow%.norg") then
      --                 vim.api.nvim_win_close(win, true)
      --             end
      --         end
      --     end,
      -- })
    '';
  };
}
