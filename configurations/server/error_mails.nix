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

  imports = [
    ./mail.nix
  ];
 
  programs.msmtp = {
    enable = true;
    defaults = {
      port = 587;
      tls = true;
    };
    accounts.default = {
      host = "smtp.gmail.com";
      from = "maarten.behn@gmail.com";
      user = "maarten.behn@gmail.com";
      password = "fg457r3";
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
