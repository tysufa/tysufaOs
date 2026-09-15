{ inputs, config, pkgs, ... }: {

  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  # sops = {
  #   # Path to your age master key
  #   age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  #   defaultSopsFile = ./secrets/secrets.yaml; # Relative path to your encrypted file
  #
  #   # CRITICAL: Hand ownership of the decrypted JSON to the cloudflared service
  #   secrets."cloudflared-creds" = {
  #     owner = "root";
  #     group = "root";
  #     mode = "0400";
  #   };
  # };

  services.cloudflared = {
    enable = true;
    tunnels = {
      "02a95328-146a-4b11-b777-e5c520d54058" = {
        protocol = "http2";
        credentialsFile = config.sops.secrets."cloudflared-creds".path;
        ingress = {
          "tysufa.com" = "http://localhost:8080";
          "dashboard.tysufa.com" = "http://100.79.190.77:8082";
          "zotero.yourdomain.com" = "http://localhost:8083";
        };
        default = "http_status:404";
      };
    };
  };
}
