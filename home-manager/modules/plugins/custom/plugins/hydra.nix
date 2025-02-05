{
  programs.nixvim = {
    plugins.hydra = {
      enable = true;

      # hydras = [
      #   {
      #     name = "Notebook";
      #     hint = "_j_/_k_: ↑/↓ | _o_/_O_: new cell ↓/↑ | _l_: run | _s_how/_h_ide | run _a_bove";
      #     config = {
      #       color = "pink";
      #       invoke_on_body = true;
      #       hint = {
      #         position = "bottom";
      #       };
      #     };
      #     mode = "n";
      #     body = "<leader>h";
      #     heads = [
      #       [
      #         "j"
      #         "]b"
      #         {
      #           silent = true;
      #         }
      #       ]
      #       [
      #         "k"
      #         "[b"
      #         {
      #           silent = true;
      #         }
      #       ]
      #       [
      #         "o"
      #         ":new cell<CR>"
      #         {
      #           silent = true;
      #         }
      #       ]
      #       [
      #         "O"
      #         ":new cell up<CR>"
      #         {
      #           silent = true;
      #         }
      #       ]
      #       [
      #         "l"
      #         ":QuartoSend<CR>"
      #         {
      #           silent = true;
      #         }
      #       ]
      #       [
      #         "s"
      #         ":noautocmd MoltenEnterOutput<CR>"
      #         {
      #           silent = true;
      #         }
      #       ]
      #       [
      #         "h"
      #         ":hide<CR>"
      #         {
      #           silent = true;
      #         }
      #       ]
      #       [
      #         "a"
      #         ":run above<CR>"
      #         {
      #           silent = true;
      #         }
      #       ]
      #     ];
      #   }
      # ];
    };

    extraConfigLuaPre = ''
                           local function keys(str)
                               return function()
                                   vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(str, true, false, true), "m", true)
                               end
                           end

                           local hydra = require("hydra")
                           hydra({
                               name = "QuartoNavigator",
                               hint = [[_j_/_k_: move 󰁅/󰁝 | _J_/_K_: cell 󰁅/󰁝 | _r_: run cell | _a_: run all | _s_: show output | _h_: hind output | O/o: create cell 󰁅/󰁝 | _R_: reset  | _E_: export cell output | _q_: 󰩈]],

                               config = {
                               show_name = true;
                                   color = "pink",
                                   invoke_on_body = true,
                         silent = true,
                                   -- hint = {
                                   --     border = "rounded", -- you can change the border if you want
                                   -- },

                               hint = {
                    type = "cmdline",
                     -- position = "",
                                --  float_opts = {
                                --        border = "rounded", -- you can change the border if you want
                                -- },
                               },

                               },
                               mode = { "n" },
                               body = "<localleader>q", -- this is the key that triggers the hydra
                               heads = {
                                   { "j",     keys("]b") },
                                   { "k",     keys("[b") },
                                   { "J",     keys("<leader>sbl") },
                                   { "E",     keys(":MoltenExportOutput<CR>") },
                                   { "K",     keys("<leader>sbh") },

                                   { "r",     ":QuartoSend<CR>" },
                                   { "q", nil,              { exit = true } },
                                   -- { "q",     nil,              { exit = true } },
                                   -- { "o", keys("/```<CR>:nohl<CR>o<CR>`<c-j>"), { desc = "new cell ↓", exit = true } },
                                   -- { "O", keys("?```.<CR>:nohl<CR><leader>kO<CR>`<c-j>"), { desc = "new cell ↑", exit = true } },
                                   { "s", ":noautocmd MoltenEnterOutput<CR>", { desc = "show" } },
                                   { "h", ":MoltenHideOutput<CR>", { desc = "hide" } },
                                   { "R", ":MoltenRestart<CR>", { desc = "restart kernel" } },
                                   { "a", ":QuartoSendAbove<CR>", { desc = "run above" } },
                               },
                           })

                           -- TODO: Сделать автоскрытие ui при выключениии гидры

                           hydra({
                               name = "DAP",
                               hint = [[
      ^            DAP
      ^
      --------------Setup--------
      _<A-u>_: Toggle UI
      _?_: Stop Debugger
      ^
      -----------Navigation------
      _t_: Run/Continue execution
      _T_: Restart DAP
      _m_: Step INTO code block
      _,_: Step OUT of code block
      _._: Step OVER code block
      ^
      -----------Breakpoint------
      _n_: Toggle Breakpoint
      _N_: Conditional Breakpoint
      ^
      ---------------------------
      _q_: Quit
      ]],

      -- _e_: Open DAP REPL

                               config = {
                               show_name = true;
                                   color = "pink",
                                   invoke_on_body = true,
                         silent = true,
                                   -- hint = {
                                   --     border = "rounded", -- you can change the border if you want
                                   -- },

                               hint = {
                    -- type = "cmdline",
                           position = "middle-right",

                                 float_opts = {

                                       border = "rounded", -- you can change the border if you want
                                },
                               },

                               },
                               mode = { "n" },
                               body = "<localleader>d", -- this is the key that triggers the hydra
                               heads = {
                { "<A-u>", function() require("dapui").toggle() end },
                  { "n", function() require("dap").toggle_breakpoint() end },
                  { "N",
                    function()
                      vim.ui.input({ prompt = "Condition: " }, function(output)
                        if output then require("dap").set_breakpoint(output) end
                      end)
                    end,
                  },
                  { "t", function() require("dap").continue() end },
                  { "T", function() require("dap").restart() end },
                  -- { "<C-h>", "Left" },
                  -- { "<C-j>", "Down" },
                  -- { "<C-k>", "Up" },
                  -- { "<C-l>", "Right" },
                  { "?",
                    function()
                      local dap = require("dap")
                      dap.terminate({}, {
                        terminateDebugee = true,
                      }, function()
                        dap.close()
                      end)
                    end },
                  { ".", function() require("dap").step_out() end },

                                   { "q", nil,              { exit = true } },
                  { ",", function() require("dap").step_over() end },
                  { "m", function() require("dap").step_into() end },                 },
            {
                "i",
                function()
                  local filetype = vim.api.nvim_get_option_value("filetype", { buf = 0 })
                  local dap = require("dap")
                  if filetype == "" then
                    filetype = "nil"
                  end
                  if dap and dap.launch_server and dap.launch_server[filetype] then
                    dap.launch_server[filetype]()
                  else
                    vim.notify(string.format("No DAP Launch server configured for filetype %s", filetype), vim.log.levels.WARN)
                  end
                end,
              },
              { "e", function() require("dap").repl.open() end },
              -- { "q", nil, { exit = true } },
                           })



    '';
  };
}
