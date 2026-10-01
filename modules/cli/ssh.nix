{ config, ... }: let 
  global_config = config;
in {
  flake.modules.homeManager.cli.programs.ssh = { 
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      ropelab = {
        hostname = "betelgeuse.uberspace.de";
        user = "ropelab";
      };
      behnserver = {
        hostname = "192.168.178.39";
        user = "Stroby";
      };

      asus = {
        #hostname = "192.168.178.169"; # Fritz-Behns
        hostname = global_config.hosts."asus".local_ip; 
        user = "stroby";
      };

      asus-private = {
        hostname = "10.1.0.2"; 
        user = "stroby";
      };

      proxy = {
        hostname = "138.199.203.38";
        user = "root";
      };

      txt = {
        hostname = "192.168.178.28";
        user = "root";
      };
    }; 
  };
}
