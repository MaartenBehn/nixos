{ pkgs, config, ... }: 
let 
  update_cloudflare_dns = pkgs.writeShellScriptBin "update_cloudflare_dns" ''
#!/usr/bin/env bash
sleep 10
CLOUDFLARE_API_TOKEN=$(cat ${config.sops.secrets."cloudflare/api_token".path})
ZONE_ID=$(cat ${config.sops.secrets."cloudflare/zone_id".path})
DNS_RECORD_ID=$(cat ${config.sops.secrets."cloudflare/aaaa_id".path})
IP6=$(curl "http://v6.ident.me")
BODY=$(jq -n \
  --arg name "stroby.org" \ 
  --argjson ttl 1 \
  --arg type "AAAA" \
  --arg comment "Update by script" \
  --arg content "$IP6" \
  --argjson proxied true)

echo "$BODY"

# https://developers.cloudflare.com/api/resources/dns/subresources/records/methods/update/
curl https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$DNS_RECORD_ID \
    -X PUT \
    -H 'Content-Type: application/json' \
    -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
    -d "$BODY"
'';

in {
  sops.secrets = {
    "cloudflare/api_token" = {};
    "cloudflare/zone_id" = {};
    "cloudflare/aaaa_id" = {};
  };

  systemd.services.cloudflare_dns_updater = {
    path = with pkgs; [
      bash
      curl
      jq
      update_cloudflare_dns
    ];
    script = "update_cloudflare_dns";
    startAt = "daily";  
    wantedBy = [ "network-online.target" ];
  };
  systemd.timers.ipv64-updater.timerConfig.RandomizedDelaySec = "15m";
}
