{
  # NOTE чет не работат
  programs.nixvim = {
    plugins.cmp_luasnip.enable = true;
    plugins.luasnip = {
      enable = true;
      fromLua = [
        {paths = ../conf/snip;}
      ];
    };
  };
}
