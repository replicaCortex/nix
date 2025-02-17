{
  programs.nixvim = {
    plugins.otter = {
      enable = true;
      # lazyLoad.settings.event = "DeferredUIEnter";
      settings.lsp.diagnostic_update_events = [
        "BufWritePost"
        "InsertLeave"
        "TextChanged"
      ];
    };
  };
}
