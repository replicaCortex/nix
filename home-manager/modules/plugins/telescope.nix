{
  programs.nixvim = {
    plugins.telescope = {
      # lazyLoad = {
      #   enable = true;
      #   settings.cmd = "Telescope";
      # };
      settings = {
        defaults = {
          file_ignore_patterns = [
            "^.mypy_cache/"
            "^.git/"
            "^__pycache__/"
            "venv"
          ];
          layout_strategy = "flex";
          layout_config = {
            preview_cutoff = 0;
            prompt_position = "top";
          };
          selection_caret = "> ";
          prompt_prefix = "=> ";
        };
        sorting_strategy = "ascending";
      };
      enable = true;

      extensions = {
        fzf-native.enable = true;
        # media-files = {
        #   enable = true;
        #   settings = {
        #     filetypes = [
        #       "png"
        #       "jpg"
        #       "gif"
        #       "mp4"
        #       "webm"
        #       "pdf"
        #     ];
        #     find_cmd = "rg";
        #   };
        #   dependencies = {
        #     chafa.enable = true;
        #     pdftoppm.enable = true;
        #   };
        # };
        ui-select.enable = false;
      };

      keymaps = {
        # "<leader>sh" = {
        #   mode = "n";
        #   action = "help_tags";
        #   options = {
        #     desc = "[S]earch [H]elp";
        #   };
        # };
        # "<leader>sk" = {
        #   mode = "n";
        #   action = "keymaps";
        #   options = {
        #     desc = "[S]earch [K]eymaps";
        #   };
        # };
        "<leader>ff" = {
          mode = "n";
          action = "find_files";
        };

        # NOTE: не работает :)

        # "<leader>ft" = {
        #   mode = "n";
        #   action = ":TodoTelescope<CR>";
        # };
        # "<leader>ss" = {
        #   mode = "n";
        #   action = "builtin";
        #   options = {
        #     desc = "[S]earch [S]elect Telescope";
        #   };
        # };
        # "<leader>sw" = {
        #   mode = "n";
        #   action = "grep_string";
        #   options = {
        #     desc = "[S]earch current [W]ord";
        #   };
        # };
        "<leader>fw" = {
          mode = "n";
          action = "live_grep";
        };

        "<leader>fb" = {
          mode = "n";
          action = "buffers";
        };

        "<leader>fd" = {
          mode = "n";
          action = "diagnostics";
        };
        # "<leader>sr" = {
        #   mode = "n";
        #   action = "resume";
        #   options = {
        #     desc = "[S]earch [R]esume";
        #   };
        # };
        "<leader>fo" = {
          mode = "n";
          action = "oldfiles";
          options = {
            desc = "[S]earch Recent Files ('.' for repeat)";
          };
        };
        # "<leader><leader>" = {
        #   mode = "n";
        #   action = "buffers";
        #   options = {
        #     desc = "[ ] Find existing buffers";
        #   };
        # };
      };
      # settings = {
      #   extensions.__raw = "{ ['ui-select'] = { require('telescope.themes').get_dropdown() } }";
      # };
    };

    keymaps = [
      {
        mode = "n";
        key = "/";
        action.__raw = ''
          function()
            require('telescope.builtin').current_buffer_fuzzy_find(
              require('telescope.themes').get_dropdown {
                winblend = 0,
                previewer = false
              }
            )
          end
        '';
        options = {
          desc = "[/] Fuzzily search in current buffer";
        };
      }
      # {
      #   mode = "n";
      #   key = "<leader>s/";
      #   # It's also possible to pass additional configuration options.
      #   #  See `:help telescope.builtin.live_grep()` for information about particular keys
      #   action.__raw = ''
      #     function()
      #       require('telescope.builtin').live_grep {
      #         grep_open_files = true,
      #         prompt_title = 'Live Grep in Open Files'
      #       }
      #     end
      #   '';
      #   options = {
      #     desc = "[S]earch [/] in Open Files";
      #   };
      # }
      # Shortcut for searching your Neovim configuration files
      # {
      #   mode = "n";
      #   key = "<leader>sn";
      #   action.__raw = ''
      #     function()
      #       require('telescope.builtin').find_files {
      #         cwd = vim.fn.stdpath 'config'
      #       }
      #     end
      #   '';
      #   options = {
      #     desc = "[S]earch [N]eovim files";
      #   };
      # }
    ];
  };
}
