{
  programs.nixvim = {
    plugins.zotcite = {
      enable = true;
      settings = {
        filetypes = [
          "markdown"
          "quarto"
        ];
        hl_cite_key = false;
        open_in_zotero = true;
        wait_attachment = true;
      };
    };
  };
}
