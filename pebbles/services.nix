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
        directory = "/mnt/storage/zotero";
        permissions = "CRUD"; # Allow Create, Read, Update, Delete
        
        users = [
          {
            username = "{env}ZOTERO_WEBDAV_USER";
            password = "{env}ZOTERO_WEBDAV_PASSWD";
          }
        ];
      };
    };

    samba = {
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = "nixos-nas";
          "security" = "user";
        };
        "SharedFiles" = {
          "path" = "/mnt/storage/shared-files";
          "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "no";
        };
      };
    };

    homepage-dashboard = {
      enable = true;
      listenPort = 8082;

      allowedHosts = "tysufa.com,192.168.1.238:8082";
      
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
                href = "http://192.168.1.238:8084";
                siteMonitor = "http://192.168.1.238:8084";
              };
            }
            {
              "Jellyfin" = {
                icon = "jellyfin";
                href = "http://192.168.1.238:8096";
                siteMonitor = "http://192.168.1.238:8096";
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
  };

  fileSystems."/var/lib/audiobookshelf" = {
    device = "/mnt/storage/audiobookshelf";
    fsType = "none";
    options = [ "bind" ];
    depends = [ "/mnt/storage" ]; # Ensures the big drive mounts first
  };

  networking.firewall.allowedTCPPorts = [ 9090 8082 8083 8084 ];

}
