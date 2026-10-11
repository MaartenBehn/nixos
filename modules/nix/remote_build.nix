{ config, ... }: let 
  global_config = config;
in {
  flake.modules.nixos.core = { pkgs, config, lib, ... }: let 
    remote_hosts = lib.filterAttrs (name: host: name != config.host && (host.remote_build.enable or false)) global_config.hosts;

    update_builders = pkgs.writeShellScript "update-active-builders" ''
      active_builders=""

      check_worker() {
        local ip="$1"
        local system="$2"
        local maxJobs="$3"
        local speedFactor="$4"
        local features="$5"

        # Check port 22 with a 1-second timeout
        if ${pkgs.netcat}/bin/nc -z -w 1 "$ip" 22 >/dev/null 2>&1; then
          # Clean layout: URI | System | IdentityFile | MaxJobs | SpeedFactor | Features
          local spec="ssh://remote_build@$ip $system /root/.ssh/remote_build $maxJobs $speedFactor $features"
          if [ -z "$active_builders" ]; then
            active_builders="$spec"
          else
            active_builders="$active_builders;$spec"
          fi
        fi
      }

      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: host: ''
        check_worker "${host.local_ip}" "${host.system}" "${toString host.remote_build.maxJobs}" "${toString host.remote_build.speedFactor}" "${lib.concatStringsSep "," host.remote_build.supportedFeatures}"
      '') remote_hosts)}

      mkdir -p /run/nix
      echo "$active_builders" > /run/nix/active_builders
    '';  
    in {
    
    users.users.remote_build = lib.mkIf config.remote_build.enable {
      isSystemUser = true;
      group = "remote_build";
      useDefaultShell = true;
      createHome = false;

      openssh.authorizedKeys.keys = [ 
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKGRprPuaJEC+YVOPhWv793MSXW+8FNgVBPLWumJFd97 root@nixos"
      ];
    };
    users.groups.remote_build = lib.mkIf config.remote_build.enable {};
    nix.settings.trusted-users = lib.mkIf config.remote_build.enable [ "remote_build" ];
    

    sops.secrets."remote_build/private_key" = {
      path = "/root/.ssh/remote_build";
    };

    nix.distributedBuilds = true;
    nix.settings.builders-use-substitutes = true;

    nix.extraOptions = ''
      builders = @/run/nix/active_builders
    '';

    system.activationScripts.updateBuilders = {
      text = "${update_builders}";
    };

    systemd.services.update-active-builders = {
      description = "Update active Nix remote builders";
      script = "${update_builders}";
      serviceConfig.Type = "oneshot";
    };

    systemd.timers.update-active-builders = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "30s";
        OnUnitActiveSec = "5min";
      };
    };
    
    nix.settings.cores = 4;
  };
}
