{ config, pkgs, ...}: {

  fileSystems."/home/tysufa/storage" =
    { 
      device = "/dev/disk/by-uuid/cca848b0-44ab-4607-b7bd-d267155b8c01";
      fsType = "btrfs";
      options = [
      "subvol=/docker-data"
      "compress=zstd"
      "noatime"
      ];
    };
}

