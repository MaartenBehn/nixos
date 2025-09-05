{ lib, config, ... }:
{
  networking.firewall = {
    allowedUDPPorts = [ 51820 ]; # Clients and peers can use the same port, see listenport
  };
  
  sops.secrets."wireguard/dont_panic.conf" = { owner = "stroby"; };
  sops.secrets."wireguard/fritz_behns.conf" = { owner = "stroby"; };

  networking.wg-quick.interfaces = {
    
    dont_panic = {  
      autostart = false;
      configFile = config.sops.secrets."wireguard/dont_panic.conf".path;
    };

    fritz_behns = {      
      autostart = false;
      configFile = config.sops.secrets."wireguard/fritz_behns.conf".path;
    };   
  };
}
