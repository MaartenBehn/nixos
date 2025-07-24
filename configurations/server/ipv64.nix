{ pkgs, ... }: 
let 
  update_ipv64 = pkgs.writeShellScriptBin "update_ipv64" ''
#!/usr/bin/env bash
curl "https://ipv64.net/nic/update?key=RP256hHTkX7nSozZsjq4LlIxvbGdOyfJ"
'';

in {
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
