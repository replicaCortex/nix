{
  programs.nixvim = {
    plugins.notebook-navigator = {
      enable = true;
      settings = {
        activate_hydra_keys = "<leader>h";
        cell_highlight_group = "Folded";
        cell_markers = {
          python = "```python";
        };
        hydra_keys = {
          add_cell_after = "b";
          add_cell_before = "a";
          comment = "c";
          move_down = "j";
          move_up = "k";
          run = "X";
          run_and_move = "x";
          split_cell = "s";
        };
        repl_provider = "molten";
        syntax_highlight = true;
      };
    };
  };
}
