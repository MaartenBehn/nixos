{ config, ... }: let 
  global_config = config;
in {
  flake.modules.nixos.core = { pkgs, config, lib, ... }: lib.mkIf {
    users.users.remotebuild = {
      isSystemUser = true;
      group = "remote_build";
      useDefaultShell = true;

      openssh.authorizedKeys.keys = [ 
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINVE2gNS9GmUx3VdDGP7Gnwv9L6WsZ/+dBrmQVulp7u/"
      ];
    };

    users.groups.remotebuild = {};

    nix.settings.trusted-users = [ "remote_build" ];
  };

  flake.modules.nixos.core = { pkgs, config, ... }: {
    sops.secrets."remote_build/private_key" = {
      path = "/root/.ssh/remote_build";
    };

    nix.distributedBuilds = true;
    nix.settings.builders-use-substitutes = true;

    nix.buildMachines = [
      {
        hostName = "remote_build@asus";
        sshUser = "remote_build";
        sshKey = "/root/.ssh/remote_build";
        system = pkgs.stdenv.hostPlatform.system;
        supportedFeatures = [ "nixos-test" "big-parallel" "kvm" ];
      }
    ];
  };

  flake.modules.homeManager.core = { config, ... } : {
    programs.ssh.matchBlocks = {
      "remote_build@asus" = {
        hostname = global_config.hosts."asus".local_ip; 
        user = "remote_build";
        
        identityFile = "${config.home.homeDirectory}/.ssh/remote_build";
        identitiesOnly = true;
      };
    };
  };
}
