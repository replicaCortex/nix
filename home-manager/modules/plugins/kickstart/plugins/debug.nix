{
  programs.nixvim = {
    # Shows how to use the DAP plugin to debug your code.
    #
    # Primarily focused on configuring the debugger for Go, but can
    # be extended to other languages as well. That's why it's called
    # kickstart.nixvim and not kitchen-sink.nixvim ;)
    # https://nix-community.github.io/nixvim/plugins/dap/index.html
    # plugins.cmp-dap.enable = true;

    plugins.dap-ui = {
      # lazyLoad.settings = {
      #   before.__raw = ''
      #     function()
      #       require('lz.n').trigger_load('nvim-dap')
      #     end
      #   '';
      #   keys = [
      #     {
      #       __unkeyed-1 = "<A-u>";
      #       __unkeyed-2.__raw = ''
      #         function()
      #           require('dap.ext.vscode').load_launchjs(nil, {})
      #           require("dapui").toggle()
      #         end
      #       '';
      #     }
      #   ];
      # };
      enable = true;

      # Set icons to characters that are more likely to work in every terminal.
      # Feel free to remove or use ones that you like more! :)
      # Don't feel like these are good choices.
      # icons = {
      #   expanded = "▾";
      #   collapsed = "▸";
      #   current_frame = "*";
      # };

      # controls = {
      #   icons = {
      #     pause = "⏸";
      #     play = "▶";
      #     step_into = "⏎";
      #     step_over = "⏭";
      #     step_out = "⏮";
      #     step_back = "b";
      #     run_last = "▶▶";
      #     terminate = "⏹";
      #     disconnect = "⏏";
      #   };
      # };
      # settins = {
      #   element_mappings = {};
      # };
      settings.layouts = [
        {
          elements = [
            {
              id = "scopes";
              size = 0.33;
            }
            {
              id = "breakpoints";
              size = 0.33;
            }
            {
              id = "stacks";
              size = 0.33;
            }
            # {
            #   id = "watches";
            #   size = 0.25;
            # }
          ];
          position = "left";
          size = 38;
        }
        {
          elements = [
            {
              id = "repl";
              size = 0.5;
            }
            {
              id = "console";
              size = 0.5;
            }
          ];
          position = "bottom";
          size = 10;
        }
      ];
      # };
    };
    plugins.dap-virtual-text = {
      # lazyLoad.settings = {
      #   before.__raw = ''
      #     function()
      #       require('lz.n').trigger_load('nvim-dap')
      #     end
      #   '';
      #   cmd = [
      #     "DapVirtualTextToggle"
      #     "DapVirtualTextEnable"
      #   ];
      # };
      enable = true;
    };
    plugins.dap-python = {
      enable = true;
    };

    plugins.dap = {
      # lazyLoad.settings = {
      #   cmd = [
      #     "DapContinue"
      #     "DapNew"
      #   ];
      # };
      enable = true;

      # extensions = {
      # Creates a beautiful debugger UI
      signs = {
        dapBreakpoint = {
          text = "";
          texthl = "white";
        };

        dapBreakpointCondition = {
          text = "";
          texthl = "white";
        };
      };
    };

    # https://nix-community.github.io/nixvim/keymaps/index.html
    keymaps = [
      {
        mode = "n";
        key = "<F5>";
        action.__raw = ''
          function()
            require('dap').continue()
          end
        '';
        options = {
          desc = "Debug: Start/Continue";
        };
      }
      {
        mode = "n";
        key = "<F11>";
        action.__raw = ''
          function()
            require('dap').step_into()
          end
        '';
        options = {
          desc = "Debug: Step Into";
        };
      }
      {
        mode = "n";
        key = "<F10>";
        action.__raw = ''
          function()
            require('dap').step_over()
          end
        '';
        options = {
          desc = "Debug: Step Over";
        };
      }
      {
        mode = "n";
        key = "<leader>dq";
        action.__raw = ''
          function()
            require('dap').terminated()
          end
        '';
        options = {
          desc = "Debug: Step Out";
        };
      }
      {
        mode = "n";
        key = "<F12>";
        action.__raw = ''
          function()
            require('dap').step_out()
          end
        '';
        options = {
          desc = "Debug: Step Out";
        };
      }
      {
        mode = "n";
        key = "<F9>";
        action.__raw = ''
          function()
            require('dap').toggle_breakpoint()
          end
        '';
      }
      # {
      #   mode = "n";
      #   key = "<leader>B";
      #   action.__raw = ''
      #     function()
      #       require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      #     end
      #   '';
      #   options = {
      #     desc = "Debug: Set Breakpoint";
      #   };
      # }
      # Toggle to see last session result. Without this, you can't see session output
      # in case of unhandled exception.
      {
        mode = "n";
        key = "<leader>du";
        action.__raw = ''
          function()
            require('dapui').toggle()
          end
        '';
        options = {
          desc = "Debug: See last session result.";
        };
      }
    ];

    # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraconfiglua#extraconfiglua
    extraConfigLua = ''
      -- require('dap').listeners.after.event_initialized['dapui_config'] = require('dapui').open
      -- require('dap').listeners.before.event_terminated['dapui_config'] = require('dapui').close
      -- require('dap').listeners.before.event_exited['dapui_config'] = require('dapui').close
    '';
  };
}
