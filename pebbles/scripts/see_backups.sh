mount /dev/disk/by-label/offline-backup /mnt/offline-backup/
sleep 0.5
restic -r /mnt/offline-backup/restic-backup snapshots
sleep 1
umount /mnt/offline-backup/
