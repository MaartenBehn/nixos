{ username, host, ...}: {
  networking = {
    hostName = (if host == "iso" then "iso" else "${username}-${host}");
    networkmanager.enable = (host != "iso");
    nameservers = [
      "8.8.8.8"
      "8.8.4.4"
      "1.1.1.1"
    ];
    firewall = {
      enable = true;
      allowedTCPPorts = [
      ];
      allowedUDPPorts = [
      ];
    };
  };

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;
}
