{
  programs.nixvim = {
    plugins.indent-blankline = {
      enable = true;
      # lazyLoad.settings.event = "DeferredUIEnter";
      settings = {
        indent = {
          char = "·";
        };
        scope = {
          show_end = false;
          show_exact_scope = true;
          show_start = false;
        };
      };
    };
  };
}
