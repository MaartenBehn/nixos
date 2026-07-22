{
  flake.modules.nixos.server = { config, ... }: {
    networking = {
      firewall.enable = true;
   
      networkmanager.enable = true;
      /*
      tempAddresses = "disabled";

      interfaces.enp3s0f3u1 = {
        macAddress = "02:11:22:33:44:55";
      };
      */
      
      networkmanager.dns = "none";
      useDHCP = false;
      dhcpcd.enable = false;
      dhcpcd.extraConfig = '' nohook resolv.conf '';
      nameservers = [ "1.1.1.1" "1.0.0.1" ];
    };
  };
}
