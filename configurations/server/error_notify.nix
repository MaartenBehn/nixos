{ pkgs, ... }: 
let
  unit_status = pkgs.writeShellScriptBin "unit_status" ''
    UNIT=$1

    EXTRA=""
    for e in "''${@:2}"; do
    EXTRA+="$e"$'\n'
    done

    UNITSTATUS=$(systemctl status $UNIT)
    
    MSG=$(cat <<EOF
    Status report for unit: $UNIT
    $EXTRA

    $UNITSTATUS
    EOF
    )

    curl -d $MSG http://localhost:8090/status
    '';
in {
  systemd.services."unit-status-fail@" = {
      serviceConfig.ExecStart = "${unit_status}/bin/unit_status %I 'Hostname: %H' 'Machine ID: %m' 'Boot ID: %b'";
      after = [ "network.target" ];
  };
  
  systemd.services."allways-fails" = {
      script = "exit -1";
      onFailure = [ "unit-status@%n.service" ];
  };
}
