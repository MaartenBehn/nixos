{ ... }: {
  
  fileSystems = {

    "/media/video_data" = {
      device = "/dev/disk/by-uuid/3d984e59-b783-45f6-b58c-ab2d6a03126d/media/video";
      fsType = "ext4";
      #options = [ # If you don't have this options attribute, it'll default to "defaults" 
      # boot options for fstab. Search up fstab mount options you can use
      #"users" # Allows any user to mount and unmount
      #"nofail" # Prevent system from failing if this drive doesn't mount
      #];
    };

    "/mnt/exampleDrive" = {
      device = "/dev/disk/by-uuid/3d984e59-b783-45f6-b58c-ab2d6a03126d";
      fsType = "ext4";
    };
  };
}
