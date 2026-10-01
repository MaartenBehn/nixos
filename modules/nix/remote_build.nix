{ config, ... }: let 
  global_config = config;
in {
  flake.modules.nixos.core = { pkgs, config, lib, ... }: 
    if config.remote_build then {
    
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

  } else {} // {

    sops.secrets."remote_build/private_key" = {
      path = "/root/.ssh/remote_build";
    };

    nix.distributedBuilds = true;
    nix.settings.builders-use-substitutes = true;

    nix.buildMachines = builtins.map (hostname: let 
        host = global_config.hosts."${hostname}";
      in {
        hostName = "remote_build@${host.local_ip}";
        sshUser = "remote_build";
        sshKey = "/root/.ssh/remote_build";
        system = host.system;
        supportedFeatures = [ "nixos-test" "big-parallel" "kvm" ];
      }) 
      (builtins.filter (hostname: hostname != config.host && global_config.hosts."${hostname}".remote_build)
       builtins.attrNames global_config.hosts);
  };
}
