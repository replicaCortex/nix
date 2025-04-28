{
  programs.btop = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName = "replicaCortex";
    userEmail = "replicaCortex@gmail.com";
    # config = {
    #   init = {
    #     defaultBranch = "main";
    #   };
    # };
    extraConfig = {
      diff.tool = "nvimdiff";
      difftool.prompt = false;
    };
  };
}
