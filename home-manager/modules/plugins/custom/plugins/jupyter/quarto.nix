{
  programs.nixvim = {
    plugins.quarto = {
      enable = true;
      settings = {
        codeRunner = {
          default_method = "molten";
        };
      };
    };
  };
}
