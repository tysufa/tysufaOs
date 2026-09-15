{ inputs, config, pkgs, ... }: {

  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    # Path to your age master key
    age.keyFile = "/home/tysufa/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets/secrets.yaml; # Relative path to your encrypted file

    # CRITICAL: Hand ownership of the decrypted JSON to the cloudflared service
    secrets."cloudflared-creds" = {
      owner = "cloudflared";
      group = "cloudflared";
      mode = "0400";
    };
  };

  services.cloudflared = {
    enable = true;
    tunnels = {
      # Replace with your actual Cloudflare Tunnel UUID
      "c5413d8d-e6f9-4986-856b-733ec52c1e20" = {
        credentialsFile = config.sops.secrets."cloudflared-creds".path;
        
        # Don't forget to re-add your ingress rules here!
        ingress = {
          "dashboard.tysufa.com" = "http://localhost:8082";
          "zotero.yourdomain.com" = "http://localhost:8083";
        };
        default = "http_status:404";
      };
    };
  };
}
