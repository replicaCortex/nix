{
  programs.zellij = {
    enable = true;
    # exitShellOnExit = true;
    enableBashIntegration = true;
  };

  home.file.configZellij = {
    source = ../../../static/zellij/config.kdl;
    target = ".config/zellij/config.kdl";
  };
}
