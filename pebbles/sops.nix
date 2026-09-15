{ inputs, config, pkgs, ... }: {

  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    # Path to your age master key
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    defaultSopsFile = ./secrets/secrets.yaml; # Relative path to your encrypted file

    # CRITICAL: Hand ownership of the decrypted JSON to the cloudflared service
    secrets."cloudflared-creds" = {
      owner = "root";
      group = "root";
      mode = "0400";
    };
  };
}


