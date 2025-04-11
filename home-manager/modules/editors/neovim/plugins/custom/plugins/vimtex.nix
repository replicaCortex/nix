{
  programs.nixvim = {
    # TODO: сделать авто закрытие и открытие toc
    plugins.vimtex = {
      enable = true;
      zathuraPackage = null;
      texlivePackage = null;
      settings = {
        compiler_method = "lualatex";
        toc_config = {
          split_pos = "vert topleft";
          split_width = 40;
        };
        view_method = "zathura";
      };
    };
  };
}
