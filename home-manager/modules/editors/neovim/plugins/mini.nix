{
  programs.nixvim = {
    # Collection of various small independent plugins/modules
    # https://nix-community.github.io/nixvim/plugins/mini.html
    plugins.mini = {
      mockDevIcons = true;
      enable = true;

      modules = {
        # ai = {
        #   n_lines = 500;
        # };

        statusline = {
        };
        icons.enable = true;
        # tabline = {};

        pairs = {};
        # surround = {
        #   mappings = {
        #     add = "gsa";
        #     delete = "gsd";
        #     find = "gsf";
        #     find_left = "gsF";
        #     highlight = "gsh";
        #     replace = "gsr";
        #     update_n_lines = "gsn";
        #   };
        # };
      };
    };

    extraConfigLua = ''
      require('mini.statusline').section_location = function()
                    return '%2l:%-2v'
      end

      -- -- TODO: инвертировать bg при выделении и наоборот
      -- vim.cmd [[
      --   highlight MiniTablineCurrent gui=underline guisp=#b4befe guibg=#181825
      --   highlight MiniTablineModifiedCurrent gui=underline guisp=#b4befe guibg=#181825 guifg=#f38ba8
      --   highlight MiniTablineModifiedVisible guifg=#f38ba8 guibg=#181825
      -- ]]
    '';

    # keymaps = [
    #   {
    #     mode = ["n"];
    #     key = "K";
    #     action.__raw = ''
    #       function ()
    #         if vim.fn.mode() == "i" then
    #           vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
    #         end
    #
    #         vim.cmd("bnext")
    #       end
    #     '';
    #     options = {
    #       silent = true;
    #     };
    #   }
    #   {
    #     mode = ["n"];
    #     key = "J";
    #     action.__raw = ''
    #       function ()
    #         if vim.fn.mode() == "i" then
    #           vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
    #         end
    #
    #         vim.cmd("bprevious")
    #       end
    #     '';
    #     options = {
    #       silent = true;
    #     };
    #   }
    #   {
    #     mode = ["n" "i"];
    #     key = "<A-n>";
    #     action = "<cmd>:bunload<CR>";
    #     options = {
    #       silent = true;
    #     };
    #   }
    #   {
    #     mode = ["n" "i"];
    #     key = "<C-c>";
    #     action = "<cmd>:bdelete<CR>";
    #     options = {
    #       silent = true;
    #     };
    #   }
    #
    #   {
    #     mode = ["n" "i"];
    #     key = "<C-C>";
    #     action = "<cmd>:bdelete!<CR>";
    #     options = {
    #       silent = true;
    #     };
    #   }
    # ];
  };
}
