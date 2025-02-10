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
              ordered_icons.__raw = ''
                {
                  ["1"] = function(i)
                    if i < 10 then
                      return "0" .. i
                    end
                    return tostring(i)
                  end;
                };

              '';

              icons = {
                todo = {
                  undone = {
                    icon = " ";
                  };
                };
                heading = {
                  icons = ["◆" "❖" "◈" "◇" "⟡" "⋄"];
                };
                delimiter = {
                  horizontal_line = {right = "textwidth";};
                };
                code_block = {
                  conceal = true;
                  spell_check = false;
                  content_only = false;
                  width = "content";
                  min_width = 85;
                  highlight = "CodeCell";
                };
              };
            };
          };

          "core.tangle" = {
            indent_errors = "print";
            report_on_empty = false;
          };
          "core.latex.renderer" = {};
          "core.defaults" = {
            __empty = null;
          };
          "core.dirman" = {
            config = {
              workspaces = {
                notes = ''~/notes'';
              };
              default_workspace = "notes";
            };
          };
          "core.integrations.treesitter" = {};
          "core.journal" = {
            config = {
              journal_folder = "2_Live";
              strategy = "flat";
              workspace = "notes";
              journals = {
              };
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
