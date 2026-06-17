{
  flake.modules.nixos.server = { config, ... }: {
    networking = {
      firewall.enable = true;
   
      networkmanager.enable = false;
      tempAddresses = "disabled";

      interfaces.enp3s0f3u1 = {
        macAddress = "02:11:22:33:44:55";
      };

      nameservers = [ "1.1.1.1" "1.0.0.1" ];
      dhcpcd.extraConfig = '' nohook resolv.conf '';
    };
  };
}
