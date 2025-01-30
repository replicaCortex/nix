{
  programs.nixvim = {
    plugins.image = {
      enable = true;
      backend = "kitty";
      maxHeight = 15;
      maxWidth = 100;
      # maxHeightWindowPercentage = 1;
      # maxWidthWindowPercentage = 1;
      editorOnlyRenderWhenFocused = true;
      tmuxShowOnlyInActiveWindow = true;
      windowOverlapClearEnabled = true;
      windowOverlapClearFtIgnore = [
        "cmp_menu"
        "cmp_docs"
        "fidget"
        ""
      ];

      # integrations = {
      #   markdown.downloadRemoteImages = false;
      #   neorg.downloadRemoteImages = false;
      # };
    };
  };
}
