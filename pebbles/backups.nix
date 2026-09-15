{ inputs, config, pkgs, ... }: {

  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

services.restic.backups.zotero = {
  # Automatically run 'restic init' if the directory is empty
  initialize = true; 

  # What to back up
  paths = [ "/mnt/storage/zotero" ];

  # Where to store the encrypted backup snapshots
  repository = "/mnt/storage/backups/zotero-repo";

  passwordFile = config.sops.secrets."restic/password".path;

  timerConfig = {
    OnCalendar = "*-*-* 23:00:00";
    Persistent = true; # If the server was turned off at the time of the backup, run immediately on boot
  };

  # Clean up older snapshots automatically
  pruneOpts = [
    "--keep-daily 7"
    "--keep-weekly 4"
    "--keep-monthly 12"
  ];
};}
