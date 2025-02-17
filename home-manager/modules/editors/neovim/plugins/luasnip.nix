{pkgs, ...}: {
  # NOTE чет не работат
  programs.nixvim = {
    plugins.cmp_luasnip.enable = true;
    plugins.luasnip = {
      enable = true;
      # fromLua = [
      #   {paths = ../conf/snip;}
      # ];
    };

    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "neorg-templates";
        src = pkgs.fetchFromGitHub {
          owner = "pysan3";
          repo = "neorg-templates";
          tag = "v2.0.3";
          sha256 = "nZOAxXSHTUDBpUBS/Esq5HHwEaTB01dI7x5CQFB3pcw=";
        };
        buildInputs = [
          pkgs.vimPlugins.luasnip
          pkgs.vimPlugins.neorg
        ];
      })
    ];
    extraConfigLuaPre = ''
      local ls = require("luasnip")
    '';

    keymaps = [
      {
        mode = "i";
        key = "<A-l>";
        action = "<cmd>:lua require'luasnip'.jump(1)<CR>";
        options = {
          silent = true;
        };
      }

      {
        mode = "i";
        key = "<A-h>";
        action = "<cmd>:lua require'luasnip'.jump(-1)<CR>";
        options = {
          silent = true;
        };
      }

      {
        mode = "i";
        key = "<A-e>";
        action.__raw = ''
          function()
            if ls.choice_active() then
              ls.change_choice(1)
            end
          end
        '';
        options = {
          silent = true;
        };
      }

      {
        mode = "n";
        key = "<A-l>";
        action.__raw = ''function() ls.jump(1) end'';
        options = {
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<A-h>";
        action.__raw = ''function() ls.jump(-1) end'';
        options = {
          silent = true;
        };
      }
    ];
  };
}
