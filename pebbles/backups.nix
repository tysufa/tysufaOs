{ inputs, config, pkgs, ... }: {

  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  services.restic.backups.serviceBackup = {
    # Automatically run 'restic init' if the directory is empty
    initialize = true; 

    # What to back up
    paths = [ "/mnt/storage/zotero" "/mnt/storage/immich" ];

    repository = "/mnt/storage/Backups/restic/";

    passwordFile = config.sops.secrets."restic/password".path;

    timerConfig = {
      OnCalendar = "*-*-* 23:00:00";
      Persistent = true; # If the server was turned off at the time of the backup, run immediately on boot
    };

    # Clean up older snapshots automatically
    pruneOpts = [
      "--keep-daily 1"
      "--keep-weekly 3"
      "--keep-monthly 5"
    ];
  };

  # we call another systemd service who will take care of mounting the drive, see : https://wiki.archlinux.org/title/Udev#Mounting_drives_in_rules 
services.udev.extraRules = ''
  ACTION=="add", SUBSYSTEM=="block", ENV{ID_FS_LABEL}=="offline-backup", TAG+="systemd", ENV{SYSTEMD_WANTS}+="restic-external-backup.service"
'';

# 2. Define the automation service that executes on plug
systemd.services.restic-external-backup = {
  description = "Automated Restic Backup to External Plugged HDD";
  after = [ "local-fs.target" ];

  path = [ pkgs.util-linux pkgs.restic ]; # needed in order to use mount, wall and restic (since they are not in $PATH by default)
  
  serviceConfig = {
    Type = "oneshot";
    # Run as root so it has permissions to mount/unmount and read all source files
    User = "root"; 
    
    ExecStart = "${pkgs.writeShellScript "restic-external-backup-handler" ''
        # terminate immediately on error
        set -e
        MNT_DIR="/mnt/offline-backup/"

        cleanup() {
          echo "Safely unmounting backup drive..."
          umount "$MNT_DIR" || true 
          echo "⚠️ RESTIC BACKUP IS COMPLETE. You can safely unplug the HDD now." | wall
        }
        # call cleanup if there is an error in the middle of the backup
        trap cleanup EXIT

        echo "External drive detected. Mounting..."
        mount /dev/disk/by-label/offline-backup "$MNT_DIR"

        echo "Starting Restic backup loop..." | wall

        export RESTIC_REPOSITORY="$MNT_DIR/restic-backup"
        export RESTIC_PASSWORD_FILE=/run/secrets/restic/offline_password
        ${pkgs.restic}/bin/restic -r $RESTIC_REPOSITORY backup /mnt/storage/zotero/ /mnt/storage/shared-files/ /mnt/storage/audiobookshelf/ /mnt/storage/immich/

        echo "Backup process finished cleanly."
      ''}";
  };
};
}
