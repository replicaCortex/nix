{
  plugins.lz-n = {
    enable = true;
    # plugins = {
    #   __unkeyed-1 = "telescope.nvim";
    #   cmd = [
    #     "Telescope"
    #   ];
    #   keys = [
    #     {
    #       __unkeyed-1 = "<leader>ff";
    #       __unkeyed-2 = "<CMD>Telescope autocommands<CR>";
    #       desc = "Telescope autocommands";
    #     }
    #     {
    #       __unkeyed-1 = "<leader>fb";
    #       __unkeyed-2 = "<CMD>Telescope buffers<CR>";
    #       desc = "Telescope buffers";
    #     }
    #   ];
    # };
    # extraConfigLuaPre = ''
    #   -- You can pass in a plugin spec or a plugin's name.
    #   local keymap = require("lz.n").keymap({
    #     "telescope.nvim",
    #     cmd = "Telescope",
    #     after = function()
    #       require("telescope").setup()
    #     end,
    #   })
    #   -- Now you can create keymaps that will load the plugin using
    #   -- the same UX as vim.keymap.set().
    #   keymap.set("n", "<leader>tp", function()
    #     require("telescope.builtin").find_files()
    #   end)
    #   keymap.set("n", "<leader>tg", function()
    #     require("telescope.builtin").live_grep()
    #   end)
    # '';
  };
}
