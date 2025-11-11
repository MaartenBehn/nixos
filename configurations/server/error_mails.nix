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

    sendmail $MAILTO <<EOF
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
      host = "gmail.com";
      from = "dontpanic355@gmail.com";
      user = "dontpanic355@gmail.com";
      password = "tfhg464fgg";
    };
  };

  systemd.services."unit-status-mail@" = {
    path = with pkgs; [
      msmtp
      unit_status_mail
    ];
    execStart = "unit_status_mail %I 'Hostname: %H' 'Machine ID: %m' 'Boot ID: %b'";
    after = [ "network.target" ];
  };

  systemd.services."allways-fails" = {
    script = "exit -1";
    onFailure = [ "unit-status-mail@%n.service" ];
  };
}
