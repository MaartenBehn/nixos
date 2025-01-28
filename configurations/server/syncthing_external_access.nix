{ ... }:
{
  networking.firewall = {
    allowedTCPPorts = [ 8384 ];
    allowedUDPPorts = [ 8384 ];
  };

}
