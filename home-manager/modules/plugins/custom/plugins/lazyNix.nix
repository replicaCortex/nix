{
  programs.nixvim = {
    plugins.lazy = {
      enable = true;
      plugins = [
        "stevearc/oil.nvim"
      ];
    };
  };
}
