{ pkgs, lib, ... }: 
let
  unit_status_mail = pkgs.writeShellScriptBin "unit_status_mail" ''
    MAILTO="stroby241@gmail.com"
    UNIT=$1

    EXTRA=""
    for e in "''${@:2}"; do
    EXTRA+="$e"$'\n'
    done

    UNITSTATUS=$(systemctl status $UNIT)

    ${pkgs.system-sendmail}/bin/sendmail $MAILTO <<EOF
    Subject:Status mail for unit: $UNIT

    Status report for unit: $UNIT
    $EXTRA

    $UNITSTATUS
    EOF

    echo -e "Status mail sent to: $MAILTO for unit: $UNIT"  
    '';
in {
 
  programs.msmtp = {
    enable = true;
    accounts.default = {
      tls = true;
      host = "gmail.com:587";
      from = "dontpanic355@gmail.com";
      user = "dontpanic355@gmail.com";
      password = "tfhg464fgg";
    };
  };

  systemd.services."unit-status-mail@" = {
    serviceConfig.ExecStart = "${unit_status_mail}/bin/unit_status_mail %I 'Hostname: %H' 'Machine ID: %m' 'Boot ID: %b'";
    after = [ "network.target" ];
  };

  systemd.services."allways-fails" = {
    script = "exit -1";
    onFailure = [ "unit-status-mail@%n.service" ];
  };
}
