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
        gtest = {
          enable = true;
        };
      };
    };
    extraConfigLuaPre = ''

      vim.keymap.set("n", "<leader>tr", function() require("neotest").run.run() end,                     { desc = "(r)un the nearest test" })
      vim.keymap.set("n", "<leader>tR", function() require("neotest").run.run(vim.fn.expand("%")) end,   { desc = "(R)un the current file" })
      vim.keymap.set("n", "<leader>tk", function() require("neotest").run.stop() end,                    { desc = "(k)ill the nearest test" })
      vim.keymap.set("n", "<leader>ta", function() require("neotest").run.attach() end,                  { desc = "(a)ttach to the nearest test" })
      vim.keymap.set("n", "<leader>to", function() require("neotest").output.open({ enter = true }) end, { desc = "open (o)utput window" })
      vim.keymap.set("n", "<leader>ts", function() require("neotest").output_panel.open() end,           { desc = "open output as (s)plit" })
      vim.keymap.set("n", "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, { desc = "run the test in (d)ebug mode" })
    '';
  };
}
