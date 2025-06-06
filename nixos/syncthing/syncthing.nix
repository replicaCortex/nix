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
          "Notebook" = {
            id = "XGFVY6I-6HYYLXW-EIRCNE5-MY5LQCM-YZWH6XF-ORFVTAM-2TORQIP-USTOEQX";
            autoAcceptFolders = true;
          };
        };

        folders = {
          "note" = {
            path = "/home/${user}/notes";
            devices = ["iPhone" "Notebook"];
          };

          "Zotero" = {
            path = "/home/${user}/Zotero";
            devices = ["Notebook"];
          };

          # "Media" = {
          #   path = "/home/${user}/Media/iPhone";
          #   devices = ["iPhone"];
          # };

          # "Vbox" = {
          #   path = "/home/${user}/workDisk/Vbox";
          #   devices = ["Notebook"];
          # };

          "code" = {
            path = "/home/${user}/code";
            devices = ["Notebook"];
          };

          # "WinShareDir" = {
          #   path = "/mnt/workspace/WinShareDir";
          #   devices = ["Notebook"];
          # };
        };

        options.globalAnnounceEnabled = false; # Only sync on LAN
      };
    };
  };
}
