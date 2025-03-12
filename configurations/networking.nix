{ username, host, ...}: {
  networking = {
    hostName = "${username}-${host}";
    networkmanager.enable = true;
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

  #environment.systemPackages = with pkgs; [ networkmanagerapplet ];
}
