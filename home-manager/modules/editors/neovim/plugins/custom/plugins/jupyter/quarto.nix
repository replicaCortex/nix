{
  programs.nixvim = {
    plugins.quarto = {
      enable = true;
      settings = {
        lspFeature = {
          diagnostics = {
            enabled = false;
            triggers = [
              "BufWritePost"
            ];
          };
        };
        codeRunner = {
          default_method = "molten";
        };
      };
    };
  };
}
