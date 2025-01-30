{
  programs.nixvim = {
    plugins.cmp-vimtex = {enable = true;};
    plugins.vimtex = {
      enable = true;
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
