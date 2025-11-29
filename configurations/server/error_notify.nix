{ pkgs, ... }: 
let
  unit_status = pkgs.writeShellScriptBin "unit_status" ''
    curl http://localhost:8090/status 
    -d "
    Status report for unit: $1
    blas 
    bjsabf
    nklsafn
    nkasjf
    nsaf"
    
    #UNIT=$1

    #EXTRA=""
    #for e in "''${@:2}"; do
    #EXTRA+="$e"$'\n'
    #done

    #UNITSTATUS=$(systemctl status $UNIT)

    #MSG=$(cat <<EOF
    #Status report for unit: $UNIT
    #$EXTRA

    #$UNITSTATUS
    #EOF
    #)

    #echo $MSG

    #curl -d "fail" http://localhost:8090/status
    '';
in {
  systemd.services."unit-status@" = {
    path = (with pkgs; [ 
      curl 
    ]);  

    serviceConfig.ExecStart = "${unit_status}/bin/unit_status %I 'Hostname: %H' 'Machine ID: %m' 'Boot ID: %b'";
    after = [ "network.target" ];
  };

  systemd.services."allways-fails" = {
    script = "exit -1";
    onFailure = [ "unit-status@%n.service" ];
  };
}
