{ ... }: {
  fileSystems = {

    "/mnt/Data" = {
      device = "/dev/disk/by-uuid/3d984e59-b783-45f6-b58c-ab2d6a03126d";
      fsType = "ext4";
    };
  };
}
