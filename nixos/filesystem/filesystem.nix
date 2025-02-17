{
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
    device = "/dev/disk/by-uuid/748b1bd2-b91a-4c1a-b089-8a8e55229775";
    fsType = "ext4";
    options = [
      "users"
      "nofail"
    ];
  };

  fileSystems."/mnt/game" = {
    device = "/dev/disk/by-uuid/2ce6d3e5-fda9-4c0f-9e3f-783a9e5802e9";
    fsType = "ext4";
    options = [
      "users"
      "nofail"
      # "uid=1000"
      # "gid=100"
      # "umask=002"
    ];
  };
}
