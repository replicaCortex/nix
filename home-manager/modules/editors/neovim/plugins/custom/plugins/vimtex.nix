{pkgs, ...}: {
  programs.nixvim = {
    # plugins.cmp-vimtex = {enable = true;};
    # TODO: сделать авто закрытие и открытие toc
    plugins.vimtex = {
      enable = true;
      zathuraPackage = null;
      texlivePackage = pkgs.texlive.combined.scheme-full;
      settings = {
        # compiler_method = "mktex";
        toc_config = {
          split_pos = "vert topleft";
          split_width = 40;
        };
        view_method = "zathura";
      };
    };
  };
}
