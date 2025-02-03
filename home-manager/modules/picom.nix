{pkgs, ...}: {
  services.picom = {
    enable = true;
    # package = pkgs.picom-pijulius;
    # shadow = true;
    # #shadowOffsets = [-8 -8];
    # shadowOpacity = 0.2;
    # shadowExclude = [
    #   "_GTK_FRAME_EXTENTS@:c"
    #   "class_g = 'Polybar'"
    # ];

    # extraArgs = [''--animations'' ''--animation-for-open-window zoom'' ''--animation-for-transient-window slide-down'' ''--animation-duration 300''];

    backend = "glx";
    vSync = true;
  };
  # home.file.picom_config = {source = ./picom.conf;};
}
