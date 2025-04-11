{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      img-clip-nvim
    ];
    extraConfigLuaPre = ''
      require"img-clip".setup {
        default = {
          dir_path = "fig",
          drag_and_drop = {
            enabled = true,
            copy_image = true,
            insert_mode = true,
          },
        },
      }
    '';
  };
}
