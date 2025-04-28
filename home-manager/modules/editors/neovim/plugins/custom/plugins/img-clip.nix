{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      img-clip-nvim
    ];
    extraConfigLuaPre = ''
      require"img-clip".setup {
        default = {
          dir_path = "fig",
        },
      }
    '';

    # autoCmd = [
    #   {
    #     callback.__raw = ''
    #       function()
    #       require"img-clip".setup {
    #         default = {
    #           dir_path = "fig",
    #         },
    #       }
    #       end
    #     '';
    #     event = [
    #       "BufEnter"
    #       "BufNewFile"
    #     ];
    #
    #     pattern = ["norg" "md" "markdown" "tex"];
    #   }
    # ];
  };
}
