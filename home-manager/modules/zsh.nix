# {pkgs, ...}:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    #autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ".." = "cd ..";
      "nixos" = "sudo nvim ~/nix/nixos/configuration.nix";
      "home" = "sudo nvim ~/nix/home-manager/modules";
      "etc" = "sudo nvim ~/nix/home-manager/modules/etc.nix";
      "hms" = "home-manager switch --flake ~/nix/";
      "nrs" = "sudo nixos-rebuild switch --flake ~/nix/";
      "systemState" = "ls -l /nix/var/nix/gcroots/auto";
      "n" = "nvim";
    };

    initExtra = ''
      setxkbmap -option grp:caps_toggle -layout us,ru

      # Start Tmux automatically if not already running. No Tmux in TTY
      if [ -z "$TMUX" ] && [ -n "$DISPLAY" ]; then
        tmux attach-session -t default || tmux new-session -s default
      fi
    '';

    zplug = {
      enable = true;
      plugins = [
        {name = "zsh-users/zsh-autosuggestions";}
      ];
    };

    oh-my-zsh = {
      enable = true;
      plugins = ["git" "thefuck" "z"];
      theme = "agnoster";
    };
  };

  # home.packages = with pkgs; [zsh-powerlevel10k];
}
