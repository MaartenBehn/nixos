{
  flake.modules.homeManager.server = { pkgs, ... }:
    {
      environment.systemPackages = [
        (pkgs.writeShellScriptBin "acme-force-renew-all" ''
          set -e

          echo "Stopping nginx..."
          systemctl stop nginx

          echo "Clearing ACME state..."
          for domain in $(ls /var/lib/acme/.lego/ 2>/dev/null); do
          rm -rf /var/lib/acme/.lego/$domain
          done

          for domain in $(ls /var/lib/acme/ | grep -v '^\.' | grep -v 'acme-challenge'); do
          rm -rf /var/lib/acme/$domain
          done

          echo "Starting ACME renewal services..."
          for svc in $(systemctl list-units --type=service --all | grep 'acme-order-renew' | awk '{print $1}' | tr -d ' '); do
          systemctl start $svc &
          done

          echo "Restarting nginx..."
          systemctl start nginx

          echo "Checking for failures..."
          failed=0
          for svc in $(systemctl list-units --type=service --all | grep 'acme-order-renew' | awk '{print $1}' | tr -d ' '); do
            if ! systemctl is-active --quiet "$svc" && systemctl show "$svc" --property=Result | grep -q 'failed\|exit-code'; then
              echo "FAILED: $svc"
              journalctl -u "$svc" --no-pager -n 10 | grep -E 'error|Error|failed|Failed|Could not'
              echo "---"
              failed=1
            fi
          done

          if [ $failed -eq 0 ]; then
            echo "All certificates renewed successfully!"
          fi        
        '')
      ];
    };
}
