{pkgs, ...}: {
  programs.nixvim = {
    plugins.image = {
      enable = true;
      backend = "ueberzug";
      # backend = "kitty";
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

      integrations = {
        markdown = {
          onlyRenderImageAtCursor = true;
        };
        neorg = {
          onlyRenderImageAtCursor = true;
        };
      };
    };

    # autoCmd = [
    #   {
    #     event = ["FileType"];
    #     pattern = ["png" "jpeg" "web"];
    #     callback.__raw = ''
    #       function()
    #       require("image").setup = image_setup_original
    #       require("image").setup()
    #       end
    #     '';
    #   }
    # ];
  };
}
