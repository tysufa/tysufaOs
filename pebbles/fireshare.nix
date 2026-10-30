{ config, pkgs, ... }:

{
  # Enable Podman backend for OCI containers
  virtualisation.oci-containers = {
    backend = "podman";
    containers.fireshare = {
      image = "docker.io/shaneisrael/fireshare:latest-lite";
      autoStart = true;
      ports = [ "8086:80" ];

      environment = {
        ADMIN_USERNAME = "tysufa";
        PUID = "1000";
        PGID = "1000";
      };

      environmentFiles = [
        config.sops.secrets."fireshare-env".path
      ];

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
