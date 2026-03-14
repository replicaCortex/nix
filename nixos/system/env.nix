{
  environment.sessionVariables = {
    # XDG Base Directories
    XDG_CONFIG_HOME = "$HOME/.var/.config";
    XDG_DATA_HOME = "$HOME/.var/.local/share";
    XDG_STATE_HOME = "$HOME/.var/.local/state";
    XDG_CACHE_HOME = "$HOME/.var/.cache";

    # Specific programs
    HISTFILE = "$HOME/.var/.local/state/bash/history";
    WGETRC = "$HOME/.var/.config/wgetrc";
    INPUTRC = "$HOME/sys/nix/.inputrc";
  };
}
