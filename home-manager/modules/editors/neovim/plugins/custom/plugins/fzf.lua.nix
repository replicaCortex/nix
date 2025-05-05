{...}: {
  programs.nixvim = {
    plugins.fzf-lua = {
      enable = true;
      settings = {
        files = {
          color_icons = true;
          file_icons = true;
          find_opts = {
            __raw = "[[-type f -not -path '*.git/objects*' -not -path '*.env*']]";
          };
          multiprocess = true;
          prompt = "Files: ";
        };
        winopts = {
          border = "rounded";
        };
        # previewers = {
        #   builtin = {
        #     extensions = {
        #       "png" = ["viu" "-b"];
        #     };
        #   };
        # };
      };

      keymaps = {
        "<leader>ff" = "files";
        "<leader>fo" = "oldfiles";
        "/" = "blines";
        "<leader>fw" = "live_grep";
        "<leader>fb" = "buffers";
        "<leader>dd" = "diagnostics_document";
        "<leader>wd" = "diagnostics_workspace";
      };
    };
    extraConfigLuaPre = ''
      vim.keymap.set({ "n", "v", "i", "c"}, "<C-x><C-f>",
        function() require("fzf-lua").complete_path() end,
        { silent = true })

      vim.keymap.set({ "i" }, "<C-x><C-f>",
        function()
          require("fzf-lua").complete_file({
            cmd = "rg --files",
            winopts = { preview = { hidden = true } }
          })
        end, { silent = true })
    '';
  };

  # home.packages = with pkgs; [viu];
}
