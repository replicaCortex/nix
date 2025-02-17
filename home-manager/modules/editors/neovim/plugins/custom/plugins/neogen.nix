{
  programs.nixvim = {
    plugins.neogen = {
      enable = true;
      snippetEngine = "luasnip";
      keymaps = {
        generate = "<localleader>dg";
      };
    };
  };
}
