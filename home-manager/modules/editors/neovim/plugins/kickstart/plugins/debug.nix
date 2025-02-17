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
      enable = true;

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
      enable = true;
    };
    plugins.dap-python = {
      enable = true;
    };

    plugins.dap-lldb = {
      package = true;
    };

    plugins.dap = {
      enable = true;

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

    extraConfigLua = ''
      -- require('dap').listeners.after.event_initialized['dapui_config'] = require('dapui').open
      -- require('dap').listeners.before.event_terminated['dapui_config'] = require('dapui').close
      -- require('dap').listeners.before.event_exited['dapui_config'] = require('dapui').close
    '';
  };
}
