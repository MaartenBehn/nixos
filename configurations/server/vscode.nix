{ pkgs, ... }: {

  networking.firewall = {
    allowedTCPPorts = [ 3000 ];
  };

  environment.systemPackages = [
    pkgs.openvscode-server
  ];
}
