{
  programs.nixvim = {
    plugins.obsidian = {
      enable = true;

      settings = {
        # ui.enable = true;
        completion = {
          min_chars = 2;
          nvim_cmp = true;
        };
        new_notes_location = "current_dir";
        workspaces = [
          {
            name = "notes";
            path = "~/notes";
          }
        ];
      };
    };
    # extraConfigLuaPre = ''
    #   vim.opt.conceallevel = 2
    # '';
  };
}
