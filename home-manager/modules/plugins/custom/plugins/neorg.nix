{pkgs, ...}: {
  programs.nixvim = {
    plugins.neorg = {
      enable = true;

      settings = {
        # lazy_loading = true;
        load = {
          "core.concealer" = {
            config = {
              icon_preset = "diamond";
            };
          };
          "core.defaults" = {
            __empty = null;
          };
          "core.dirman" = {
            config = {
              workspaces = {
                notes = ''~/notes/'';
              };
              default_workspace = "notes";
            };
          };
          "core.completion" = {
            config = {
              engine = "nvim-cmp";
            };
          };
        };
      };
      telescopeIntegration.enable = true;
    };
  };
}
