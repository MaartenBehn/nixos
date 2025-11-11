{ pkgs, ... }: 
let
  unit_status_mail = pkgs.writeShellScriptBin "unit_status_mail" ''
    MAILTO="stroby241@gmail.com"
    MAILFROM="unit-status-mailer"
    UNIT=$1

    EXTRA=""
    for e in "''${@:2}"; do
    EXTRA+="$e"$'\n'
    done

    UNITSTATUS=$(systemctl status $UNIT)

    sendmail $MAILTO <<EOF
    From:$MAILFROM
    To:$MAILTO
    Subject:Status mail for unit: $UNIT

    Status report for unit: $UNIT
    $EXTRA

    $UNITSTATUS
    EOF

    echo -e "Status mail sent to: $MAILTO for unit: $UNIT"  
    '';
in { 
  systemd.services."unit-status-mail@" = {
    path = with pkgs; [
      system-sendmail
      unit_status_mail
    ];
    script = "unit_status_mail %I 'Hostname: %H' 'Machine ID: %m' 'Boot ID: %b'";
    after = [ "network.target" ];
  };

  systemd.services."allways-fails" = {
    script = "exit -1";
    onFailure = [ "unit-status-mail@%n.service" ];
  };
}
