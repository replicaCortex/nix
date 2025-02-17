{
  programs.nixvim = {
    plugins.harpoon = {
      enable = true;
      # enableTelescope = true;
      keymaps = {
        addFile = ''<localleader>H'';
        toggleQuickMenu = ''<localleader>h'';
        navFile = {
          "1" = "H";
          "2" = "J";
          "3" = "K";
          "4" = "L";
        };
      };
      keymapsSilent = true;
      menu = {
        width = 35;
        height = 8;
      };
    };
    # extraConfigLuaPre = ''
    # '';
  };
}
