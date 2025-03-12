{pkgs, ...}: {
  networking = {
    # hostName = ""; Should be defined host/<name>/configuartion.nix
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
