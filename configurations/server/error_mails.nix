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

    ssmtp $MAILTO <<EOF
    Subject:Status mail for unit: $UNIT

    Status report for unit: $UNIT
    $EXTRA

    $UNITSTATUS
    EOF

    echo -e "Status mail sent to: $MAILTO for unit: $UNIT"  
    '';
in {

  # Throw away gmail account.
  environment.etc."ssmtp/ssmtp.conf".text = lib.mkForce ''
    root=dontpanic355@gmail.com
    mailhub=smtp.gmail.com:465
    FromLineOverride=YES
    AuthUser=dontpanic355@gmail.com
    AuthPass=tfhg464fgg
    UseTLS=YES
  '';

  systemd.services."unit-status-mail@" = {
    path = with pkgs; [
      ssmtp
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
