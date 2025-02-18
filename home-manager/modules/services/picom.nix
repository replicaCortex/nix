{
  services.picom = {
    enable = true;
    # package = pkgs.picom-pijulius;

    # extraArgs = [''--animations'' ''--animation-for-open-window zoom'' ''--animation-for-transient-window slide-down'' ''--animation-duration 300''];

    backend = "glx";
    vSync = true;
    settings = {
      fading = true;
      fade-in-step = 0.1;
      fade-out-step = 0.1;

      # animations = true;
      # animation-stiffness = 180.0;
      # animation-dampening = 28.0;
      # animation-clamping = true;
      # animation-mass = 1;
      # animation-for-open-window = "zoom";
      # animation-for-menu-window = "slide-down";
      # animation-for-transient-window = "slide-down";
      #
      # animation-for-workspace-switch-in = "slide-down";
      # animation-for-workspace-switch-out = "slide-up";
    };
  };

  # home.file.picom_config = {
  #   source = ./conf/picom/picom.conf;
  #   target = ".config/picom/picom.conf";
  # };
}
