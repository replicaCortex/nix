{
  programs.nixvim = {
    plugins.treesitter = {
      enable = true;

      settings = {
        # auto_install = true;
        # ensureInstalled = [
        #   "bash"
        #   "norg"
        #   "norg_meta"
        #   "diff"
        #   "lua"
        #   "markdown"
        #   "markdown_inline"
        #   "python"
        #   "latex"
        # ];

        highlight = {
          enable = true;
        };
      };
    };
  };
}
