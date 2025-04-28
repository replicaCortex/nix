{
  programs.nixvim = {
    plugins.flash = {
      enable = true;
      settings = {
        modes = {
        };
        prompt = {
          enabled = true;
          prefix = [["FastFastFast!!!" "FlashPromptIcon"]];
        };
      };
    };

    keymaps = [
      {
        mode = ["o" "x" "n"];
        key = "s";
        action.__raw = ''
          function() require("flash").jump({ restore = true, motion = true }) end
        '';
      }

      {
        mode = ["o" "x" "n"];
        key = "S";
        action.__raw = ''
          function()
          require("flash").treesitter({remote_op = { restore = true, motion = true },})
          end
        '';
      }

      {
        mode = ["o" "x" "n"];
        key = "R";
        action.__raw = ''
          function()
          require("flash").treesitter_search({remote_op = { restore = true, motion = true },})
          end
        '';
      }

      {
        mode = ["o" "x" "n"];
        key = "r";
        action.__raw = ''
          function()
          require("flash").remote({remote_op = { restore = true, motion = true },})
          end
        '';
      }

      # {
      #   mode = "n";
      #   key = "r";
      #   action.__raw = ''
      #     function() require("flash").remote() end
      #   '';
      # }
    ];
  };
}
