let
  user = "replica";
in {
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";

  services = {
    syncthing = {
      enable = true;
      openDefaultPorts = true;
      dataDir = "/home/${user}/.local/share/syncthing";
      configDir = "/home/${user}/.config/syncthing";
      user = "${user}";
      group = "users";
      guiAddress = "127.0.0.1:8384";
      overrideFolders = true;
      overrideDevices = true;

      settings = {
        devices = {
          "iPhone" = {
            id = "ZUZETR5-7AGAECV-MOYWSOL-666OHH7-X7K53FQ-IPDI7VP-ELJ5JIO-GXMDEQF";
            autoAcceptFolders = true;
            allowedNetwork = "192.168.0.0/16";
            addresses = ["tcp://192.168.0.99:51820"];
          };
          "Notebook" = {
            id = "WW5O366-THBBBA3-HKQAYCP-EWADS4I-4KDDC5Z-3JCO42M-RLBZ3DY-NM7PEQA";
            allowedNetwork = "192.168.0.0/16";
            autoAcceptFolders = true;
            addresses = ["tcp://192.168.0.103:51820"];
          };
        };

        folders = {
          "notes" = {
            # id = "ukrub-quh7k";
            path = "/home/${user}/Desktop/notes";
            devices = ["iPhone"];
          };
        };

        options.globalAnnounceEnabled = false; # Only sync on LAN
      };
    };
  };
}
