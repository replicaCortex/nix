{
  programs.nixvim = {
    plugins.neotest = {
      # lazyLoad = {
      #   settings = {
      #     keys = [
      #       {
      #         __unkeyed-1 = "<leader>nt";
      #         __unkeyed-3 = "<CMD>Neotest summary<CR>";
      #       }
      #       {
      #         __unkeyed-1 = "<leader>dn";
      #         __unkeyed-3.__raw = ''
      #           function()
      #             require("neotest").run.run({strategy = "dap"})
      #           end
      #         '';
      #       }
      #       {
      #         __unkeyed-1 = "<leader>na";
      #         __unkeyed-3 = "<CMD>Neotest attach<CR>";
      #       }
      #       {
      #         __unkeyed-1 = "<leader>nd";
      #         __unkeyed-3.__raw = ''
      #           function()
      #             require("neotest").run.run({strategy = "dap"})
      #           end
      #         '';
      #       }
      #       {
      #         __unkeyed-1 = "<leader>nh";
      #         __unkeyed-3 = "<CMD>Neotest output<CR>";
      #       }
      #       {
      #         __unkeyed-1 = "<leader>no";
      #         __unkeyed-3 = "<CMD>Neotest output-panel<CR>";
      #       }
      #       {
      #         __unkeyed-1 = "<leader>nr";
      #         __unkeyed-3 = "<CMD>Neotest run<CR>";
      #       }
      #       {
      #         __unkeyed-1 = "<leader>nR";
      #         __unkeyed-3.__raw = ''
      #           function()
      #             require("neotest").run.run(vim.fn.expand("%"))
      #           end
      #         '';
      #       }
      #       {
      #         __unkeyed-1 = "<leader>ns";
      #         __unkeyed-3 = "<CMD>Neotest stop<CR>";
      #       }
      #     ];
      #   };
      # };
      enable = true;
      settings = {
        # status = {
        #   enable = true;
        #   virtual_text = true;
        # };
        output = {
          enabled = true;
          open_on_run = true;
        };
        output_panel = {
          enabled = true;
          open = "botright split | resize 15";
        };
        quickfix = {
          enabled = false;
        };
      };
      adapters.python = {
        enable = true;
      };
    };
    extraConfigLuaPre = ''

      -- require("neotest").setup({
      --   adapters = {
      --     require("neotest-python")({
      --       runner = "pytest",
      --       dap = { justMyCode = false },
      --     }),
      --   },
      -- })


      -- vim.keymap.set("n", "<leader>tt", function() require("neotest").run.run() end, { desc = "Run nearest test" })
      -- vim.keymap.set("n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, { desc = "Run tests in file" })
      -- vim.keymap.set("n", "<leader>ta", function() require("neotest").run.run({ suite = true }) end, { desc = "Run all tests" })
      -- vim.keymap.set("n", "<leader>ts", function() require("neotest").summary.toggle() end, { desc = "Toggle test summary" })
      -- vim.keymap.set("n", "<leader>to", function() require("neotest").output_panel.toggle() end, { desc = "Toggle output panel" })
    '';
  };
}
