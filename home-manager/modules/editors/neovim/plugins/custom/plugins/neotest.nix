{
  programs.nixvim = {
    plugins.neotest = {
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
      adapters = {
        python = {
          enable = true;
        };
        dotnet = {
          enable = true;
        };
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


      vim.keymap.set("n", "<leader>tt", function() require("neotest").run.run() end, { desc = "Run nearest test" })
      vim.keymap.set("n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, { desc = "Run tests in file" })
      vim.keymap.set("n", "<leader>ta", function() require("neotest").run.run({ suite = true }) end, { desc = "Run all tests" })
      vim.keymap.set("n", "<leader>ts", function() require("neotest").summary.toggle() end, { desc = "Toggle test summary" })
      vim.keymap.set("n", "<leader>to", function() require("neotest").output_panel.toggle() end, { desc = "Toggle output panel" })
    '';
  };
}
