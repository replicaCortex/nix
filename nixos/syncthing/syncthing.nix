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
            id = "NF6WLE2-A5FX6HP-EPXYGB7-27CPH46-6Q33EXN-PZ2I677-76EFSUR-XQBNTAV";
            autoAcceptFolders = true;
          };
          "NixOS" = {
            id = "E7XVWRA-AHFE7R5-Y4TMTAM-HZTW56I-OPLBX56-UO5NO57-667RQ35-APMJEAH";
            allowedNetwork = "192.168.0.0/16";
            autoAcceptFolders = true;
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
          # "Vbox" = {
          #   path = "/home/${user}/Vbox";
          #   devices = ["NixOS"];
          # };
          "Project Manager" = {
            path = "/home/${user}/Desktop/ProjectManager";
            devices = ["NixOS"];
          };
        };

        options.globalAnnounceEnabled = false; # Only sync on LAN
      };
    };
  };
}
