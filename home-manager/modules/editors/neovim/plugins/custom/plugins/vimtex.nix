{
  programs.nixvim = {
    # TODO: сделать авто закрытие и открытие toc
    plugins.vimtex = {
      enable = true;
      zathuraPackage = null;
      texlivePackage = null;
      xdotoolPackage = null;
      settings = {
        compiler_method = "lualatex";
        toc_config = {
          split_pos = "vert topleft";
          split_width = 40;
        };
        view_method = "zathura";
      };
    };
    extraConfigLuaPre = ''
      vim.g.vimtex_fold_enabled = 1  -- включить складки в vimtex
      vim.g.vimtex_fold_manual = 0   -- автоматически создавать складки
      vim.g.vimtex_fold_types = {
        sections = {
          enabled = 1,  -- сворачивать \section, \subsection и т.д.
        },
        environments = {
          blacklist = {}, -- окружения, которые не надо сворачивать
          enabled = 1,    -- сворачивать \begin{...} \end{...}
        },
      }
    '';
  };
}
