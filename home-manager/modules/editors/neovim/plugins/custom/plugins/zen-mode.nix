{
  programs.nixvim = {
    plugins.zen-mode = {
      enable = true;
    };

    extraPlugins = [
      # (pkgs.vimUtils.buildVimPlugin {
      #   name = "centerpad.nvim";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "smithbm2316";
      #     repo = "centerpad.nvim";
      #     rev = "666641d02fd8c58ac401c1fb6bf596bb00b815fb";
      #     hash = "sha256-clHJFfU7F95WYpGVGr3iQEN+00lnS9YxIpLOoH56e68=";
      #   };
      # })
    ];
  };
}
