{ system_name, host, ...}: {
  networking = {
    hostName = system_name;
    networkmanager.enable = (host != "iso");
    #nameservers = [
    #  "8.8.8.8"
    #  "8.8.4.4"
    #  "1.1.1.1"
    #  "10.184.193.20"  # DLR DNS
    #  "172.21.154.193" # DLR DNS
    #  "208.67.222.222" # open DNS
    #  "208.67.220.220" # open DNS
    #];
    firewall = {
      enable = true;
      allowedTCPPorts = [
        24727 # Ausweiß App
      ];
      allowedUDPPorts = [
        24727 # Ausweiß App
      ];
    };
  };

  services.gnome.gnome-keyring.enable = true;
  #security.pam.services.sddm.enableGnomeKeyring = true;


}
