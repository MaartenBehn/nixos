{ pkgs, ... }: {
  services.samba = {
    # The full package is needed to register mDNS records (for discoverability), see discussion in
    # https://gist.github.com/vy-let/a030c1079f09ecae4135aebf1e121ea6
    package = pkgs.samba4Full;
    usershares.enable = true;
    enable = true;
    openFirewall = true;
  };

  # To be discoverable with windows
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  # Make sure your user is in the samba group
  users.users.stroby = {
    extraGroups = [ "samba" ];
  };

  environment.systemPackages = with pkgs; [
    kdePackages.qtsvg 
    kdePackages.dolphin # This is the actual dolphin package

    kdePackages.kio # needed since 25.11
    kdePackages.kio-fuse #to mount remote filesystems via FUSE
    kdePackages.kio-extras #extra protocols support (sftp, fish and more)
  ];
}
