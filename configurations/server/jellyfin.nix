{ ... }:
{
  services.jellyfin.enable = true;
  networking.firewall.allowedUDPPorts = [ 7359 ];
  # Client Discovery (7359/UDP): Allows clients to discover Jellyfin on the local network. A broadcast message to this port will return detailed information about your server that includes name, ip-address and ID.

  networking.firewall.allowedTCPPorts = [ 8096 ];
}
