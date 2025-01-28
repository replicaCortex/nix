{pkgs, ...}: {
  programs.nixvim = {
    plugins.neorg = {
      enable = true;

      settings = {
        load = {
          "core.concealer" = {
            config = {
              icon_preset = "varied";
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
          # "core.integrations.telescope" = {};
          # "core.integrations.treesitter" = {};
        };
      };
      telescopeIntegration.enable = true;
    };
    extraConfigLuaPre = ''
      -- local load = {
      --  ["core.completion"] = {
      --     -- config = { engine = { module_name = "external.lsp-completion" } },
      --     config = { engine = "nvim-cmp" },
      --   },
      -- }
      -- require("neorg").setup({ load = load })
    '';

    # extraPlugins = [
    #   (pkgs.vimUtils.buildVimPlugin {
    #     name = "neorg-interim-ls";
    #     src = pkgs.fetchFromGitHub {
    #       owner = "benlubas";
    #       repo = "neorg-interim-ls";
    #       rev = "5784d9ef77b97a421fb7b344b387db4c8e84e0a8";
    #       hash = "sha256-Cveb65H3qVN/uC/nVdBwshXGetcWmY1E3glcQ7kN+hw=";
    #     };
    #   })
    # ];
  };
}
