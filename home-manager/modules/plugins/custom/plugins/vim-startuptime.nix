{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "vim-startuptime";
        src = pkgs.fetchFromGitHub {
          owner = "dstein64";
          repo = "vim-startuptime";
          # rev = "1a7d6b1dfb2f176715ccc9e838be32d044f8a734";
          tag = "v4.5.0";
          # sha256 = "4KFGlFcaV+X98gK+VeR0spceDpy108wk19LYd/oUXc0=";
          sha256 = "hQ7/e7vEJx3j4CQfA6zkQFSe6wrFc9URZ2z47ZulW9A=";
        };
      })
    ];
  };
}
