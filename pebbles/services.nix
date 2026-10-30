{ inputs, config, pkgs, ... }: {

  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  services = {
      
    tailscale.enable = true;

    webdav = {
      enable = true;

      user = "tysufa";
      group = "users";

      environmentFile = config.sops.templates."webdav-env".path;

      settings = {
        address = "0.0.0.0"; # Listen on all network interfaces
        port = 8083;

        permissions = "CRUD";

        cors = {
          enabled = true;
          credentials = true;
        };

        users = [
          {
            username = "{env}ZOTERO_WEBDAV_USER";
            password = "{env}ZOTERO_WEBDAV_PASSWD";
            directory = "/mnt/storage/zotero";
            permissions = "CRUD";
          }
          {
            username = "{env}OBSIDIAN_WEBDAV_USER";
            password = "{env}OBSIDIAN_WEBDAV_PASSWD";
            directory = "/mnt/storage/obsidian";
            permissions = "CRUD";
          }
        ];
      };
    };

    homepage-dashboard = {
      enable = true;
      listenPort = 8082;

      allowedHosts = "homepage.tysufa.com,192.168.1.238:8082";
      
      services = [
        {
          "Academic Services" = [
            {
              "Zotero Cloud Vault" = {
                icon = "zotero";
                href = "http://192.168.1.238:8083";
                description = "Native background cloud storage for your library files";
                siteMonitor = "http://192.168.1.238:8083";
              };
            }
          ];
        }

        {
          "Medias" = [
            {
              "Audiobookshelf" = {
                icon = "audiobookshelf";
                href = "https://audiobookshelf.tysufa.com";
                siteMonitor = "https://audiobookshelf.tysufa.com";
              };
            }
            {
              "Kavita" = {
                icon = "kavita";
                href = "https://kavita.tysufa.com";
                siteMonitor = "https://kavita.tysufa.com";
              };
            }
            {
              "Jellyfin" = {
                icon = "jellyfin";
                href = "http://192.168.1.238:8096";
                siteMonitor = "http://192.168.1.238:8096";
              };
            }
            {
              "CopyParty" = {
                icon = "copyparty";
                href = "https://copyparty.tysufa.com";
                siteMonitor = "https://copyparty.tysufa.com";
              };
            }
            {
              "Fireshare" = {
                icon = "fireshare";
                href = "https://fireshare.tysufa.com";
                siteMonitor = "https://fireshare.tysufa.com";
              };
            }
            {
              "Immich" = {
                icon = "immich";
                href = "https://immich.tysufa.com";
                siteMonitor = "https://immich.tysufa.com";
              };
            }
          ];
        }
      ];
    };
  
    audiobookshelf = {
      enable = true;
      port = 8084;
      host = "0.0.0.0";
      openFirewall = true;
    };

    immich = {
      enable = true;
      port = 2283;
      host = "0.0.0.0";
      openFirewall = true;
      mediaLocation = "/mnt/storage/immich";
    };

    jellyfin = {
      enable = true;
      openFirewall = true;
    };

    kavita = {
      enable = true;
      dataDir = "/mnt/storage/kavita";
      tokenKeyFile = config.sops.secrets."kavita-token-key".path;
      settings = {
        Port = 5000;
      };
    };

  };

  fileSystems."/var/lib/audiobookshelf" = {
    device = "/mnt/storage/audiobookshelf";
    fsType = "none";
    options = [ "bind" ];
    depends = [ "/mnt/storage" ]; # Ensures the big drive mounts first
  };

  networking.firewall.allowedTCPPorts = [ 9090 8082 8083 8084 3923 3910];

}
