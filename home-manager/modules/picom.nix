{pkgs, ...}: {
  services.picom = {
    enable = true;
    package = pkgs.picom-pijulius;

    extraArgs = [''--animations'' ''--animation-for-open-window zoom'' ''--animation-for-transient-window slide-down'' ''--animation-duration 300''];

    backend = "glx";
    vSync = true;
  };
}
