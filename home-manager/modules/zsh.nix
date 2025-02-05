{
  pkgs,
  lib,
  ...
}: {
  programs.zsh = {
    enable = false;
    # enableCompletion = true;
    # autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      "na" = "bluetoothctl connect E4:61:F4:31:88:26";
      "r" = "ranger";
      ".." = "cd ..";
      "nixos" = "sudo nvim ~/nix/nixos/configuration.nix";
      "home" = "sudo nvim ~/nix/home-manager/modules";
      "etc" = "sudo nvim ~/nix/home-manager/modules/etc.nix";
      "hms" = "home-manager switch --flake ~/nix/";
      "nrs" = "sudo nixos-rebuild switch --flake ~/nix/";
      "systemState" = "ls -l /nix/var/nix/gcroots/auto";
      "n" = "nvim .";
      "nb" = "nix build ./";
      "nd" = "nix develop ./";
      "nr" = "nix run";
      "jn" = "jupyter notebook";
    };

    # plugins = [
    #   {name = "zsh-users/zsh-autosuggestions";}
    #   {
    #     name = "powerlevel10k";
    #     src = pkgs.zsh-powerlevel10k;
    #   }
    # ];
    initExtra = ''
      setxkbmap -option grp:caps_toggle -layout us,ru

      # Start Tmux automatically if not already running. No Tmux in TTY
      if [ -z "$TMUX" ] && [ -n "$DISPLAY" ]; then
        tmux attach-session -t default || tmux new-session -s default
      fi
    '';

    # zplug = {
    #   enable = true;
    #   plugins = [
    #     {name = "zsh-users/zsh-autosuggestions";}
    #   ];
    # };

    # oh-my-zsh = {
    #   enable = true;
    #   plugins = ["git" "thefuck" "z" "sudo"];
    #   theme = "agnoster";
    #   extraConfig = '''';
    # };
  };

  # home.packages = with pkgs; [zsh-powerlevel10k];
}
