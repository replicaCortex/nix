{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "volt";
        src = pkgs.fetchFromGitHub {
          owner = "nvzone";
          repo = "volt";
          rev = "1a7d6b1dfb2f176715ccc9e838be32d044f8a734";
          sha256 = "4KFGlFcaV+X98gK+VeR0spceDpy108wk19LYd/oUXc0=";
        };
      })
    ];
  };
}
