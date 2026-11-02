{ config, ... }: let 
  global_config = config;
in {
  my.secrets.laptop."laptop_stroby_ssh_private_key" = {
    bitwarden = { name = "Laptop"; field = "private_key"; };
    path = "/home/stroby/.ssh/id_ed25519";
    owner = "stroby";
  };

  my.secrets.laptop."laptop_stroby_ssh_key_public_key" = {
    bitwarden = { name = "Laptop"; field = "public_key"; };
    path = "/home/stroby/.ssh/id_ed25519.pub";
    owner = "stroby";
  };

  flake.modules.nixos.core = {
    programs.ssh = {
      extraConfig = ''
        Host *
          StrictHostKeyChecking accept-new
      '';
    };
  };

  flake.modules.homeManager.cli.programs.ssh = { 
    enable = true;
    enableDefaultConfig = false;
    settings = {
      ropelab = {
        hostname = "betelgeuse.uberspace.de";
        user = "ropelab";
      };
      behnserver = {
        hostname = "192.168.178.39";
        user = "Stroby";
      };

      asus = {
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

      pigman = {
        hostname = global_config.hosts."pigman".local_ip; 
        user = "stroby";
      };
    }; 
  };
}
