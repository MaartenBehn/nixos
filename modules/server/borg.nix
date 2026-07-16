{
  flake.modules.nixos.server = { 
    # Important: 
    # To read files from an other group the group has the specified in the config 
    # giving the borg user the group does not work!
    #
    # For backup to fritz_behns
    # borg users ~/.ssh/id_ed25519.pub must be added to authorized_key in DiskStation
    # https://blog.aaronlenoir.com/2018/05/06/ssh-into-synology-nas-with-ssh-key/

    users.users.borg = {
      isNormalUser = true;
    };
  };
}
