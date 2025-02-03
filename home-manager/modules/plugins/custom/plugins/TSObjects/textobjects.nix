{
  home.file = {
    ".config/nvim/queries/markdown/textobjects.scm".text = ''
      ;; extends

      (fenced_code_block (code_fence_content) @code_cell.inner) @code_cell.outer
    '';
  };
}
