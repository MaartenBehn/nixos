{
  flake.modules.nixos.hotspot = {
    networking.firewall.allowedUDPPorts = [ 67 68 ];
  };
}
