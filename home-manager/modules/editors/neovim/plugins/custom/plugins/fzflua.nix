{
  lib,
  pkgs,
  ...
}: {
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
          prompt = "Files❯ ";
        };
        winopts = {
          col = 0.3;
          height = 0.4;
          row = 0.99;
          width = 0.93;
          border = "rounded";
        };
      };

      keymaps = {
        "<leader>ff" = "buffers";
        "<leader>fo" = "oldfiles";
        "<C-/>" = "blines";
        "<leader>fg" = "live_grep";
        "<C-p>" = {
          action = "git_files";
          settings = {
            previewers.cat.cmd = lib.getExe' pkgs.coreutils "cat";
            winopts.height = 0.5;
          };
          options = {
            silent = true;
          };
        };
      };
    };
  };
}
