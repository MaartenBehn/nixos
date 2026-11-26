{  
  flake.modules.nixos.server = { config, pkgs, lib, ... }: let

    ntfyUrl = config.services.ntfy-sh.settings.base-url + "/status";

    # Script invoked by smartd when a drive warning/error occurs
    smartdNotify = pkgs.writeShellScript "smartd-ntfy" ''
      ${pkgs.curl}/bin/curl -fsS \
      -H "Title: Drive SMART Alert ($SMARTD_DEVICE)" \
      -H "Priority: urgent" \
      -H "Tags: rotating_light,floppy_disk" \
      -d "$SMARTD_MESSAGE" \
      "${ntfyUrl}" >/dev/null
      '';
  in
    {
    services.smartd = {
      enable = true;
      autodetect = true;
      # -a: monitor all attributes
      # -o on -S on: enable automatic offline testing & attribute autosave
      # -n standby,q: do not wake sleeping/standby drives (prevents spin-up spam on USB HDDs)
      # -W 4,45,55: warn if temp changes by 4C, hits 45C info, or 55C critical
      # -m <nomailer> -M exec ...: trigger custom ntfy script instead of sendmail
      defaults.autodetected = "-a -o on -S on -n standby,q -W 4,45,55 -m <nomailer> -M exec ${smartdNotify}";
    };

    # 2. Periodic CPU, RAM, and disk-space checks via systemd timer
    systemd.services.sys-health-ntfy = {
      description = "Check CPU, RAM, and filesystem thresholds and alert via ntfy";
      path = with pkgs; [ coreutils gawk procps curl nettools ];
      serviceConfig = {
        Type = "oneshot";
        StateDirectory = "sys-health-ntfy"; # Automatically creates /var/lib/sys-health-ntfy
      };
      script = ''
      set -euo pipefail

      NTFY_URL="${ntfyUrl}"
      STATE_DIR="/var/lib/sys-health-ntfy"
      HOST=$(hostname)

      # Thresholds
      CPU_LOAD_WARN="6.0"   # Set near your logical CPU core count
      MEM_USED_WARN=70      # Percent
      DISK_USED_WARN=70     # Percent
      COOLDOWN=21600        # 6 hours between repeat alerts for the same issue

      send_alert() {
        local key="$1"
        local title="$2"
        local msg="$3"
        local stamp_file="$STATE_DIR/$key"

        if [[ -f "$stamp_file" ]] && (( $(date +%s) - $(cat "$stamp_file") < COOLDOWN )); then
          return 0
        fi

        curl -fsS \
        -H "Title: $title" \
        -H "Priority: high" \
        -H "Tags: warning,computer" \
        -d "$msg" \
        "$NTFY_URL" >/dev/null

        date +%s > "$stamp_file"
      }

      # CPU 1-minute load average
      load1=$(awk '{print $1}' /proc/loadavg)
      if awk -v l="$load1" -v w="$CPU_LOAD_WARN" 'BEGIN { exit !(l > w) }'; then
        send_alert "cpu_load" "High CPU Load ($HOST)" "1-min load average is $load1 (threshold: $CPU_LOAD_WARN)"
      fi

      # RAM usage %
      mem_pct=$(free | awk '/^Mem:/ { printf "%.0f", ($3/$2)*100 }')
      if (( mem_pct >= MEM_USED_WARN )); then
        send_alert "ram_usage" "High RAM Usage ($HOST)" "Memory usage is at ''${mem_pct}% (threshold: ''${MEM_USED_WARN}%)"
      fi

      # Filesystem usage %
      while read -r pct mount; do
        pct_num=''${pct%\%}
        if [[ "$pct_num" =~ ^[0-9]+$ ]] && (( pct_num >= DISK_USED_WARN )); then
          safe_key="disk_$(echo "$mount" | tr '/ ' '__')"
          send_alert "$safe_key" "Disk Space Low ($HOST)" "Mount $mount is at $pct full"
        fi
      done < <(df -hP -x tmpfs -x devtmpfs -x squashfs -x efivarfs | awk 'NR>1 {print $5, $6}')
      '';
    };

    systemd.timers.sys-health-ntfy = {
      description = "Run system health check every 5 minutes";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "2m";
        OnUnitActiveSec = "5m";
        Persistent = true;
      };
    };
  };
}
