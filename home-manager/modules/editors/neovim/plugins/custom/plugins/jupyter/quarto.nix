{
  programs.nixvim = {
    plugins.quarto = {
      enable = true;
      settings = {
        lspFuature = {
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
