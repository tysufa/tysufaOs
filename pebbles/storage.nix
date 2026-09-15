{ config, pkgs, ...}: {

systemd.tmpfiles.rules = [
  "d /mnt/storage/ 0755 tysufa users -"
];

  fileSystems."/mnt/storage" =
    { 
      device = "/dev/disk/by-uuid/cca848b0-44ab-4607-b7bd-d267155b8c01";
      fsType = "btrfs";
      options = [
      "subvol=/"
      "compress=zstd"
      "noatime"
      ];
    };
}

