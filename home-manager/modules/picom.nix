{
  services.picom = {
    enable = true;
    shadow = true;
    #shadowOffsets = [-8 -8];
    shadowOpacity = 0.2;
    shadowExclude = [
      "_GTK_FRAME_EXTENTS@:c"
      "class_g = 'Polybar'"
    ];

    backend = "glx";
    vSync = true;
  };
}
