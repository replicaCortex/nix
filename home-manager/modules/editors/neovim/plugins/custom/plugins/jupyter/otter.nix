{
  programs.nixvim = {
    plugins.otter = {
      enable = true;
      settings.lsp.diagnostic_update_events = [
        "BufWritePost"
        "InsertLeave"
        "TextChanged"
      ];
    };
  };
}
