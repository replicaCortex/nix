{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "nnn.nvim";
        src = pkgs.fetchFromGitHub {
          owner = "luukvbaal";
          repo = "nnn.nvim";
          rev = "662034c73718885ee599ad9fb193ab1ede70fbcb";
          sha256 = "8+ax8n1fA4jgJugvWtRXkad4YM7TmAAsAopzalmGu/4=";
        };
      })
    ];
    extraConfigLuaPre = ''
      require("nnn").setup({
        -- picker = {
        --   cmd = "tmux new-session nnn -Pp",
        --   style = { border = "rounded" },
        --   session = "shared",
        -- },
        -- replace_netrw = "picker",
        -- windownav = "<C-l>"
        -- builtin = {
        -- mappings = {
        -- { "<C-t>", builtin.open_in_tab },       -- open file(s) in tab
        -- { "<C-s>", builtin.open_in_split },     -- open file(s) in split
        -- { "<C-v>", builtin.open_in_vsplit },    -- open file(s) in vertical split
        -- { "<C-p>", builtin.open_in_preview },   -- open file in preview split keeping nnn focused
        -- { "<C-y>", builtin.copy_to_clipboard }, -- copy file(s) to clipboard
        -- { "<C-w>", builtin.cd_to_path },        -- cd to file directory
        -- { "<C-e>", builtin.populate_cmdline },  -- populate cmdline (:) with file(s)
        -- },
        -- },
      })
    '';
  };
}
