{
  programs.nixvim = {
    plugins.render-markdown = {
      enable = true;
    };
    extraConfigLuaPre = ''
      -- require('render-markdown').setup({
      --
      --   checkbox = {
      --       enabled = true,
      --   },
      --   bullet = {enabled = false, },
      --   })

    '';
  };
}
