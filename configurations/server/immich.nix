{ config, pkgs, ... }: 
let 
  default_borg_settings = import ./borg_settings.nix;
  fix_permissions = pkgs.writeShellScriptBin "fix_permissions" ''
    chmod -R 750 /var/lib/immich 
  ''; 

in {
  imports = [ ./borg.nix ];

  services.postgresql.ensureUsers = [ 
    { 
      name = "immich";
      ensureDBOwnership = true;
    }
  ];

  environment.systemPackages = with pkgs; [
    immich-cli
  ]; 

  services.immich = {
    enable = true;
    port = 2283;
  };

  # hardware acceleration 
  services.immich.accelerationDevices = null;
  users.users.immich.extraGroups = [ "video" "render" ];
  hardware.graphics.enable = true;

  web_services = [
    {
      sub_domain = "immich";
      config = {
        proxyPass = "http://[::1]:${toString config.services.immich.port}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
          extraConfig = ''
            client_max_body_size 50000M;
            proxy_read_timeout   600s;
            proxy_send_timeout   600s;
            send_timeout         600s;
          '';      
      };
    }
  ];
 
  systemd.services.borgbackup-job-fritz_behns_immich = {
    vpnConfinement = {
      enable = true;
      vpnNamespace = "fritz";
    };
    requires = [ "fritz_behns_vpn_check.service" "borg_immich_fix_permissions.service" ];
    after = [ "fritz_behns_vpn_check.service" "borg_immich_fix_permissions.service" ];
    onFailure = [ "unit-status@%n.service" ];
  };

  systemd.services.borg_immich_fix_permissions = {
    serviceConfig.Type = "oneshot";
    
    path = [
      fix_permissions
    ];
    script = "fix_permissions";
  };

  services.borgbackup.jobs.fritz_behns_immich = default_borg_settings // {
    group = "immich";
    paths = "/var/lib/immich";
    repo = "ssh://Stroby@192.168.178.39/volume1/BackUp/asus_server/immich";
    startAt = "Sat 04:00";
  };
}
