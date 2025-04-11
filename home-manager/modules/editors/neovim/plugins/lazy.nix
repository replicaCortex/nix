{
  programs.nixvim = {
    plugins.lz-n = {
      enable = true;
    };

    colorschemes.catppuccin = {
      lazyLoad.enable = true;
    };

    plugins.neorg = {
      lazyLoad.settings = {
        cmd = "Neorg";
        ft = "norg";
      };
    };

    plugins.image = {
      lazyLoad.settings = {
        ft = ["norg" "md" "markdown"];
      };
    };

    # plugins.hydra = {
    #   lazyLoad.settings = {
    #     keys = [
    #       "<localleader>du"
    #       "<localleader>n"
    #     ];
    #   };
    # };

    plugins.neotest = {
      lazyLoad.settings = {
        keys = [
          "<leader>tr"
          "<leader>tR"
          "<leader>tk"
          "<leader>ta"
          "<leader>to"
          "<leader>ts"
          "<leader>td"
        ];
      };
    };

    plugins.indent-blankline = {
      lazyLoad.settings.event = "DeferredUIEnter";
    };

    plugins.quarto = {
      lazyLoad.settings = {
        ft = ["md" "markdown"];
      };
    };

    plugins.colorizer = {
      lazyLoad.settings = {
        ft = ["ini" "css" "html" "toml" "js" "ts" "yaml"];
      };
    };

    plugins.conform-nvim = {
      lazyLoad.settings = {
        # ft = ["*"];
        event = "BufWritePre";
      };
    };

    # plugins.lsp = {
    #   lazyLoad.settings = {
    #     # ft = ["*"];
    #     event = "InsertEnter";
    #   };
    # };

    # plugins.cmp = {
    #   lazyLoad.settings = {
    #     # ft = ["*"];
    #     event = "InsertEnter";
    #   };
    # };

    # plugins.otter = {
    #   lazyLoad.settings = {
    #     ft = ["md" "markdown"];
    #   };
    # };
  };
}
