{
  programs.nixvim = {
    plugins.zk = {
      enable = true;
      settings = {picker = "fzf_lua";};
    };
  };
}
