{
  programs.nixvim = {
    keymaps = [
      {
        mode = "n";
        key = "<C-n>";
        action = "<CMD>Oil<CR>";
      }

      # {
      #   mode = "n";
      #   key = "<leader>oi";
      #   action.__raw = ''
      #
      #     function()
      #         local oil = require(" oil ")
      #         local filename = oil.get_cursor_entry().name
      #         local dir = oil.get_current_dir()
      #         oil.close()oil
      #
      #         local img_clip = require(" img-clip ")
      #         img_clip.paste_image({}, dir .. filename)
      #       end
      #
      #   '';
      # }
    ];
    plugins.oil = {
      # lazyLoad = {
      #   enable = true;
      #   settings = {
      #     keys = [
      #       {"<C-n>" = "<CMD>Oil<CR>";}
      #     ];
      #   };
      # };
      enable = true;
      settings = {
        keymaps = {
          "<C-c>" = false;
          "<C-l>" = false;
          "<localleader>p" = ''actions.preview'';
          # "<C-r>" = false;
          "<C-n>" = "actions.close";
          "." = "actions.toggle_hidden";
          "<localleader>/" = "actions.toggle_hidden";
          "l" = "actions.select";
          "h" = "actions.parent";
        };
      };
    };

    extraConfigLuaPre = ''

      -- vim.api.nvim_create_autocmd("User", {
      --   pattern = "OilEnter",
      --   callback = vim.schedule_wrap(function(args)
      --     local oil = require("oil")
      --     if vim.api.nvim_get_current_buf() == args.data.buf and oil.get_cursor_entry() then
      --       oil.open_preview()
      --     end
      --   end),
      -- })


      -- vim.api.nvim_create_autocmd("User", {
      --   pattern = "OilEnter",
      --   callback = vim.schedule_wrap(function(args)
      --     local oil = require("oil")
      --     if vim.api.nvim_get_current_buf() == args.data.buf and oil.get_cursor_entry() then
      --       oil.open_preview()
      --     end
      --   end),
      -- })

    '';
  };
}
