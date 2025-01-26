{
  programs.nixvim = {
    plugins.colorizer = {
      enable = true;
      settings = {
        user_default_options = {
          mode = "virtualtext";
          names = false;
          virtualtext = " ";
          virtualtext_inline = true;
        };
      };
    };
  };
}
