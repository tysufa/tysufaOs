{ inputs, config, pkgs, ... }: {

  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    # Path to your age master key
    age.keyFile = "/home/tysufa/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets/secrets.yaml; # Relative path to your encrypted file
    defaultSopsFormat = "yaml";

    # CRITICAL: Hand ownership of the decrypted JSON to the cloudflared service
    secrets.cloudflared-creds = {
      owner = "root";
      group = "root";
      mode = "0400";
    };

    secrets."zotero/password" = {};
    secrets."zotero/username" = {};

    templates."webdav-env".content = ''
      ZOTERO_WEBDAV_USER="${config.sops.placeholder."zotero/username"}"
      ZOTERO_WEBDAV_PASSWD="${config.sops.placeholder."zotero/password"}"
    '';

    secrets."restic/password" = {
      owner = "root";
      group = "root";
      mode = "0400";
    };
    secrets."restic/offline_password" = {
      owner = "root";
      group = "root";
      mode = "0400";
    };
  };
}


