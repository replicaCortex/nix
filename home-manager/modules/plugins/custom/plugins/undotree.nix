{
  programs.nixvim = {
    plugins.undotree = {
      enable = true;
    };
    keymaps = [
      {
        key = "<leader>u";
        action = ":UndotreeToggle<CR>:UndotreeFocus<CR>";
        options = {
          silent = true;
        };
      }
    ];
  };
}
