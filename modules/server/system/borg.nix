{
  my.secrets.server."borg_server_passphrase" = {
    bitwarden = { name = "Borg"; field = "password"; };
    owner = "borg"; 
  };
 
  flake.modules.nixos.server = { 
    # Important: 
    # To read files from an other group the group has the specified in the config 
    # giving the borg user the group does not work!
    #
    # For backup to fritz_behns
    # borg users ~/.ssh/id_ed25519.pub must be added to authorized_key in DiskStation
    # https://blog.aaronlenoir.com/2018/05/06/ssh-into-synology-nas-with-ssh-key/

    users.users.borg = {
      isNormalUser = true;
    };
  };

  flake.modules.homeManager.server = { pkgs, ... }: let
    borg_status = pkgs.writeShellApplication {
      name = "borg-status";
      runtimeInputs = [ pkgs.systemd pkgs.gawk pkgs.coreutils ];
      text = ''
          echo "=================================================="
          echo "          Borg Backup Jobs Status Report          "
          echo "=================================================="

          units=$(systemctl list-units --full --all --no-legend 'borgbackup-job-*.service' | awk '{print $1}')

          if [ -z "$units" ]; then
            echo "No borgbackup systemd units found."
            exit 0
          fi

          for unit in $units; do
            active_state=$(systemctl show -p ActiveState --value "$unit")
            sub_state=$(systemctl show -p SubState --value "$unit")
            result=$(systemctl show -p Result --value "$unit")
            exit_code=$(systemctl show -p ExecMainStatus --value "$unit")

            if [ "$result" = "success" ] && [ "$sub_state" = "dead" ]; then
              status="✅ SUCCESS"
            elif [ "$active_state" = "active" ]; then
              status="🔄 RUNNING"
            else
              status="❌ FAILED (result: $result, exit code: $exit_code)"
            fi

            echo ""
            echo "Job:     $unit"
            echo "Status:  $status"

            last_log=$(journalctl -u "$unit" -n 1 --no-pager --output=short-iso 2>/dev/null | tail -n 1)
            if [ -n "$last_log" ]; then
              echo "Last Run: $last_log"
            else
              echo "Last Run: No recent logs found"
            fi
            echo "--------------------------------------------------"
          done
          '';
    };
  in {
    home.packages = [
      borg_status
    ];
  };
}
