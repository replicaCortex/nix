{
  programs.nixvim = {
    plugins.render-markdown = {
      enable = true;
      # lazyLoad = {
      #   enable = true;
      #   settings.ft = "markdown";
      # };
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
