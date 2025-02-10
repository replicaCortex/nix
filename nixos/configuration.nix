# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  ...
}: let
  fuck = ''$'';
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # nixpkgs.overlays = [(final: prev: {picom = prev.pkgs.picom-pijulius;})];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.pulseaudio.enable = false;
  hardware.alsa.enablePersistence = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true; # if not already enabled
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  fonts = {
    fontconfig = {
      antialias = false;
      localConf = ''
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
        <fontconfig>
           <match target="pattern">
              <test qual="any" name="family">
                 <string>GohuFont14 Mono Nerd Font</string>
              </test>

              <test qual="any" name="family">
                 <string>GohuFont11 Mono Nerd Font</string>
              </test>


              <test qual="any" name="family">
                 <string>ProggyClean NerdFont</string>
              </test>
              <edit name="antialias" mode="assign">
                 <bool>false</bool>
              </edit>
              <edit name="hinting" mode="assign">
                 <bool>false</bool>
              </edit>
           </match>
        </fontconfig>
      '';
    };
  };
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us,ru";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.

  # programs.zsh.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
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
      "nv" = "nvim .";
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
    shellInit = ''
      setxkbmap -option grp:caps_toggle -layout us,ru

      # Start Tmux automatically if not already running. No Tmux in TTY
      if [ -z "$TMUX" ] && [ -n "$DISPLAY" ]; then
        tmux attach-session -t default || tmux new-session -s default
      fi

      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      export EDITOR="nvim"
      export TERMINAL="alacritty";
      export BROWSER="firefox"

      #-----
      export NNN_OPTS="H"
      export NNN_FIFO=/tmp/nnn.fifo
      # export NNN_OPTS="deH"
      export LC_COLLATE="C" # hidden files on top
      export NNN_FIFO="/tmp/nnn.fifo"
      export NNN_PLUG='p:preview-tabbed'
      #-----

      n ()
      {

          if [ -n $NNNLVL ] && [ "${fuck}{NNNLVL:-0}" -ge 1 ]; then
              echo "nnn is already running"
              return
          fi
          export NNN_TMPFILE="${fuck}{XDG_CONFIG_HOME:-${fuck}HOME/.config}/nnn/.lastd"
          nnn "$@"
          if [ -f "$NNN_TMPFILE" ]; then
                  . "$NNN_TMPFILE"
                  rm -f "$NNN_TMPFILE" > /dev/null
          fi
      }

    '';

    # plugins = [
    #   {
    #     name = "powerlevel10k";
    #     src = pkgs.zsh-powerlevel10k;
    #     file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    #   }
    # ];

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
  users.defaultUserShell = pkgs.zsh;

  users.users.replica = {
    isNormalUser = true;
    description = "replica";
    extraGroups = ["networkmanager" "wheel" "vboxsf"];
    packages = with pkgs; [];
  };

  # Enable automatic login for the user.
  services.getty.autologinUser = "replica";

  environment.systemPackages = with pkgs; [
    zsh-powerlevel10k
    home-manager
    osu-lazer
    alsa-utils
  ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.package = pkgs.bluez;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  # services.blueman.enable = true;

  # hardware.nvidia.package = let
  #   rcu_patch = pkgs.fetchpatch {
  #     url = "https://github.com/gentoo/gentoo/raw/c64caf53/x11-drivers/nvidia-drivers/files/nvidia-drivers-470.223.02-gpl-pfn_valid.patch";
  #     hash = "sha256-eZiQQp2S/asE7MfGvfe6dA/kdCvek9SYa/FFGp24dVg=";
  #   };
  # in
  #   config.boot.kernelPackages.nvidiaPackages.mkDriver {
  #     version = "535.154.05";
  #     sha256_64bit = "sha256-fpUGXKprgt6SYRDxSCemGXLrEsIA6GOinp+0eGbqqJg=";
  #     sha256_aarch64 = "sha256-G0/GiObf/BZMkzzET8HQjdIcvCSqB1uhsinro2HLK9k=";
  #     openSha256 = "sha256-wvRdHguGLxS0mR06P5Qi++pDJBCF8pJ8hr4T8O6TJIo=";
  #     settingsSha256 = "sha256-9wqoDEWY4I7weWW05F4igj1Gj9wjHsREFMztfEmqm10=";
  #     persistencedSha256 = "sha256-d0Q3Lk80JqkS1B54Mahu2yY/WocOqFFbZVBh+ToGhaE=";
  #
  #     patches = [rcu_patch];
  #   };

  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.graphics = {
    enable = true;
  };
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  services.xserver = {
    enable = true;
    windowManager.bspwm.enable = true;
    displayManager.lightdm = {
      enable = true;
      background = ../home-manager/modules/conf/background/nixos-wallpaper-catppuccin-mocha.png;
      greeters.slick.enable = true;
    };
    desktopManager.xterm.enable = false;

    # https://github.com/dustinlyons/nixos-config/tree/main

    screenSection = ''
      Option       "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
      Option       "AllowIndirectGLXProtocol" "off"
      Option       "TripleBuffer" "on"
    '';
  };

  # services = {
  #   picom = {
  #     enable = true;
  #     settings = {
  #       animations = true;
  #       animation-stiffness = 300.0;
  #       animation-dampening = 35.0;
  #       animation-clamping = false;
  #       animation-mass = 1;
  #       animation-for-workspace-switch-in = "auto";
  #       animation-for-workspace-switch-out = "auto";
  #       animation-for-open-window = "slide-down";
  #       animation-for-menu-window = "none";
  #       animation-for-transient-window = "slide-down";
  #       backend = "glx";
  #       vsync = true;
  #     };
  #     #variant = "grp:caps_toggle";
  #     #options = "grp:caps_toggle";
  #   };
  # };

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
    };
  };

  fileSystems."/mnt/course" = {
    device = "/dev/disk/by-uuid/963E4CE23E4CBD4D";
    fsType = "ntfs-3g";
    options = [
      "users"
      "nofail"
    ];
  };

  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/5AA0538EA0536F8D";
    fsType = "ntfs-3g";
    options = [
      "users"
      "nofail"
    ];
  };

  fileSystems."/mnt/workspace" = {
    device = "/dev/disk/by-uuid/8E5CD8B45CD89873";
    fsType = "ntfs-3g";
    options = [
      "users"
      "nofail"
    ];
  };

  fileSystems."/mnt/game" = {
    device = "/dev/disk/by-uuid/2ACE5DF0CE5DB4B3";
    fsType = "ntfs-3g";
    options = [
      "users"
      "nofail"
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
