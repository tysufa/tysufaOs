{ config, pkgs, ... }:

{
  # Enable Podman backend for OCI containers
  virtualisation.oci-containers = {
    backend = "podman";
    containers.fireshare = {
      image = "shaneisrael/fireshare:latest";
      autoStart = true;
      ports = [ "8086:80" ];

      environment = {
        ADMIN_USERNAME = "tysufa";
        ADMIN_PASSWORD = "deskiwis"; # Recommended: migrate to sops-nix secret later
        PUID = "1000";
        PGID = "1000";
      };

      volumes = [
        "/mnt/storage/fireshare/data:/data:rw"
        "/mnt/storage/fireshare/processed:/processed:rw"
        "/mnt/storage/fireshare/videos:/videos:rw"
        "/mnt/storage/fireshare/images:/images:rw"
      ];
    };
  };

  # Firewall rule
  networking.firewall.allowedTCPPorts = [ 8084 ];
}
