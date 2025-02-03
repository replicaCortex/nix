{
  config,
  pkgs,
  ...
}: let
  tex = pkgs.texlive.combine {
    inherit
      (pkgs.texlive)
      scheme-full
      # hyperref
      # multicol
      # darkmode
      # multicolrule
      # adjustbox
      # mnhyphn
      # cyrillic
      ;
    #(setq org-latex-compiler "lualatex")
    #(setq org-preview-latex-default-process 'dvisvgm)
  };
in {
  # home-manager
  home.packages = with pkgs; [
    tex
  ];
}
