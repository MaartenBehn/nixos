{ pkgs, config, ... }: 
let 
  update_ipv64 = pkgs.writeShellScriptBin "update_ipv64" ''
#!/usr/bin/env bash
sleep 10
KEY=$(cat ${config.sops.secrets."ipv64/key".path})
curl "https://ipv64.net/nic/update?key=$KEY"
'';

in {
  sops.secrets."ipv64/key" = {};

  systemd.services.ipv64-updater = {
    path = with pkgs; [
      bash
      curl
      update_ipv64
    ];
    script = "update_ipv64";
    startAt = "hourly";  
    wantedBy = [ "network-online.target" ];
  };
  systemd.timers.ipv64-updater.timerConfig.RandomizedDelaySec = "15m";
}
