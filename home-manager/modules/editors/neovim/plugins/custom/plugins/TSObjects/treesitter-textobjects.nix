{pkgs, ...}: {
  programs.nixvim = {
    plugins.treesitter-textobjects = {
      enable = true;
    };
    #   move = {
    #     enable = true;
    #     setJumps = false;
    #     gotoNextStart.__raw = ''
    #       {
    #         ["]b"] = { query = "@code_cell.inner" }
    #       }
    #     '';
    #     gotoPreviousStart.__raw = ''
    #       {
    #          ["[b"] = { query = "@code_cell.inner" }
    #       }
    #     '';
    #   };
    #   # select = {
    #   #   enable = true;
    #   #   lookahead = true;
    #   #   keymaps = {
    #   #     __raw = ''
    #   #       {
    #   #         ["ib"] = { query = "@code_cell.inner", desc = "in block" }
    #   #         ["ab"] = { query = "@code_cell.outer", desc = "around block" }
    #   #       }
    #   #     '';
    #   #   };
    #   # };
    # };

    # extraPlugins = with pkgs.vimPlugins; [
    #   nvim-treesitter-textobjects
    #
    #   # multiple-cursors
    # ];
    extraConfigLuaPre = ''

              require("nvim-treesitter.configs").setup({
          -- ... other ts config
          textobjects = {
              move = {
                  enable = true,
                  set_jumps = false, -- you can change this if you want.
                  goto_next_start = {
                      --- ... other keymaps
                      ["]b"] = { query = "@code_cell.inner", desc = "next code block" },
                  },
                  goto_previous_start = {
                      --- ... other keymaps
                      ["[b"] = { query = "@code_cell.inner", desc = "previous code block" },
                  },
              },
              select = {
                  enable = true,
                  lookahead = true, -- you can change this if you want
                  keymaps = {
                      --- ... other keymaps
                      ["ib"] = { query = "@code_cell.inner", desc = "in block" },
                      ["ab"] = { query = "@code_cell.outer", desc = "around block" },
                  },
              },
              swap = { -- Swap only works with code blocks that are under the same
                       -- markdown header
                  enable = true,
                  swap_next = {
                      --- ... other keymap
                      ["<leader>sbl"] = "@code_cell.outer",
                  },
                  swap_previous = {
                      --- ... other keymap
                      ["<leader>sbh"] = "@code_cell.outer",
                  },
              },
          }
      })

    '';
  };
}
