{
  programs.nixvim = {
    # Highlight, edit, and navigate code
    # https://nix-community.github.io/nixvim/plugins/treesitter/index.html
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
