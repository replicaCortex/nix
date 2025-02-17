{
  programs.nixvim = {
    # Collection of various small independent plugins/modules
    # https://nix-community.github.io/nixvim/plugins/mini.html
    plugins.mini = {
      mockDevIcons = true;
      enable = true;

      modules = {
        # Better Around/Inside textobjects
        #
        # Examples:
        #  - va)  - [V]isually select [A]round [)]paren
        #  - yinq - [Y]ank [I]nside [N]ext [Q]uote
        #  - ci'  - [C]hange [I]nside [']quote
        # ai = {
        #   n_lines = 500;
        # };

        # Add/delete/replace surroundings (brackets, quotes, etc.)
        #
        # Examples:
        #  - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
        #  - sd'   - [S]urround [D]elete [']quotes
        #  - sr)'  - [S]urround [R]eplace [)] [']
        # surround = {
        # };

        # Simple and easy statusline.
        #  You could remove this setup call if you don't like it,
        #  and try some other statusline plugin
        statusline = {
          # use_icons.__raw = "vim.g.have_nerd_font";
        };
        icons.enable = true;
        tabline = {};

        pairs = {};
        # notify = {};

        # ... and there is more!
        # Check out: https://github.com/echasnovski/mini.nvim
      };
    };

    # You can configure sections in the statusline by overriding their
    # default behavior. For example, here we set the section for
    # cursor location to LINE:COLUMN
    # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraconfiglu#extraconfiglua
    extraConfigLua = ''
      require('mini.statusline').section_location = function()
                    return '%2l:%-2v'
      end

      vim.cmd [[
        highlight MiniTablineCurrent gui=underline guisp=#b4befe
        highlight MiniTablineModifiedCurrent gui=underline guisp=#b4befe guifg=#f38ba8
        highlight MiniTablineModifiedVisible guifg=#f38ba8
      ]]
    '';
    keymaps = [
      {
        mode = "n";
        key = "<A-.>";
        action = "<cmd>:bnext<CR>";
        options = {
          silent = true;
        };
      }

      {
        mode = "n";
        key = "<A-n>";
        action = "<cmd>:bunload<CR>";
        options = {
          silent = true;
        };
      }

      {
        mode = "n";
        key = "<A-,>";
        action = "<cmd>:bprevious<CR>";
        options = {
          silent = true;
        };
      }

      {
        mode = "n";
        key = "<A-c>";
        action = "<cmd>:bdelete<CR>";
        options = {
          silent = true;
        };
      }

      {
        mode = "n";
        key = "<A-C>";
        action = "<cmd>:bdelete!<CR>";
        options = {
          silent = true;
        };
      }
    ];
  };
}
