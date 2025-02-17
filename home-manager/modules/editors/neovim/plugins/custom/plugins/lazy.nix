{
  programs.nixvim = {
    plugins.lazy = {
      enable = true;
      plugins = [
        "willothy/wezterm.nvim"
      ];
    };
  };
}
