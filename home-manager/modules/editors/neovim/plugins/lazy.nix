{
  programs.nixvim = {
    colorschemes.catppuccin = {
      lazyLoad.enable = true;
    };

    plugins = {
      lz-n = {
        enable = true;
      };

      fzf-lua.lazyLoad.settings.event = "DeferredUIEnter";

      # fzf-lua.lazyLoad = {
      # settings = {
      #   keys = [
      #     "<leader>ff"
      #     "<leader>fo"
      #     "/"
      #     "<leader>fw"
      #     "<leader>fb"
      #     "<leader>dd"
      #     "<leader>wd"
      #   ];
      # };
      # };

      neorg = {
        lazyLoad.settings = {
          cmd = "Neorg";
          ft = "norg";
        };
      };

      image = {
        lazyLoad.settings = {
          ft = ["norg" "md" "markdown" "png" "jpg" "webm"];
        };
      };

      # hydra = {
      #   lazyLoad.settings = {
      #     keys = [
      #       "<localleader>du"
      #       "<localleader>n"
      #     ];
      #   };
      # };

      # neotest = {
      #   lazyLoad.settings = {
      #     keys = [
      #       "<leader>tr"
      #       "<leader>tR"
      #       "<leader>tk"
      #       "<leader>ta"
      #       "<leader>to"
      #       "<leader>ts"
      #       "<leader>td"
      #     ];
      #   };
      # };

      indent-blankline = {
        lazyLoad.settings.event = "DeferredUIEnter";
      };

      # quarto = {
      #   lazyLoad.settings = {
      #     ft = ["md" "markdown"];
      #   };
      # };

      colorizer = {
        lazyLoad.settings = {
          ft = ["ini" "css" "html" "toml" "js" "ts" "yaml"];
        };
      };

      conform-nvim = {
        lazyLoad.settings = {
          # ft = ["*"];
          event = "BufWritePre";
        };
      };

      # lsp = {
      #   lazyLoad.settings = {
      #     # ft = ["*"];
      #     event = "InsertEnter";
      #   };
      # };

      # cmp = {
      #   lazyLoad.settings = {
      #     # ft = ["*"];
      #     event = "InsertEnter";
      #   };
      # };

      # otter = {
      #   lazyLoad.settings = {
      #     ft = ["md" "markdown"];
      #   };
      # };
    };
  };
}
