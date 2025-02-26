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
          "NixOS" = {
            id = "E7XVWRA-AHFE7R5-Y4TMTAM-HZTW56I-OPLBX56-UO5NO57-667RQ35-APMJEAH";
            allowedNetwork = "192.168.0.0/16";
            autoAcceptFolders = true;
            addresses = ["tcp://192.168.0.103:51820"];
          };
        };

        folders = {
          "notes" = {
            path = "/home/${user}/Desktop/notes";
            devices = ["iPhone" "NixOS"];
          };
          "Zotero" = {
            path = "/home/${user}/Zotero";
            devices = ["NixOS"];
          };
          "Vbox" = {
            path = "/home/${user}/Vbox";
            devices = ["NixOS"];
          };
          "Project Manager" = {
            path = "/home/${user}/Desktop/Project Manager";
            devices = ["NixOS"];
          };
        };

        options.globalAnnounceEnabled = false; # Only sync on LAN
      };
    };
  };
}
