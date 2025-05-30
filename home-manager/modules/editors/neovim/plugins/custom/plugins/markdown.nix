{
  programs.nixvim = {
    plugins.render-markdown = {
      enable = true;
    };
    # extraConfigLuaPre = ''
    # '';

    autoCmd = [
      {
        event = ["BufWritePost"];
        pattern = "*.md";
        callback.__raw = ''
          function()
            local view = vim.fn.winsaveview()
            vim.cmd("normal! gg=G")
            vim.fn.winrestview(view)
          end
        '';
      }
    ];
  };
}
