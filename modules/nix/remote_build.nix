{ config, ... }: let 
  global_config = config;
in {
  flake.modules.nixos.core = { pkgs, config, lib, ... }: {
    
    users.users.remote_build = lib.mkIf config.remote_build {
      isSystemUser = true;
      group = "remote_build";
      useDefaultShell = true;
      createHome = false;

      openssh.authorizedKeys.keys = [ 
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKGRprPuaJEC+YVOPhWv793MSXW+8FNgVBPLWumJFd97 root@nixos"
      ];
    };
    users.groups.remote_build = lib.mkIf config.remote_build {};
    nix.settings.trusted-users = lib.mkIf config.remote_build [ "remote_build" ];


    sops.secrets."remote_build/private_key" = {
      path = "/root/.ssh/remote_build";
    };

    nix.distributedBuilds = true;
    nix.settings.builders-use-substitutes = true;

    nix.buildMachines = builtins.map (hostname: let 
        host = global_config.hosts."${hostname}";
      in {
        hostName = "${host.local_ip}";
        sshUser = "remote_build";
        sshKey = "/root/.ssh/remote_build";
        system = host.system;
        supportedFeatures = [ "nixos-test" "big-parallel" "kvm" ];
      }) 
      (builtins.filter (hostname: hostname != config.host && global_config.hosts."${hostname}".remote_build)
       (builtins.attrNames global_config.hosts));
  };
}
