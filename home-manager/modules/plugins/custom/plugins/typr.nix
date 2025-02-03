{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "typr";
        src = pkgs.fetchFromGitHub {
          owner = "nvzone";
          repo = "typr";
          rev = "249fd11305e9adf92762474691e00f5a32b12f6e";
          sha256 = "IOjx8jyB3OIUa2zo5gp+yskPEFdIE4Z+b/cORa7g4N0=";
        };
      })
    ];

    # extraPlugins = with pkgs.vimPlugins; [
    #   nvzone-typr
    #   # nvzone-minty
    #   nvzone-volt
    # ];
  };
}
