{
  flake.modules.nixos.server = { pkgs, lib, ... }: 
  let
    unit_status = pkgs.writeShellScriptBin "unit_status" ''
      UNIT=$1

      EXTRA=""
      for e in "''${@:2}"; do
        EXTRA+="$e"$'\n'
      done

      UNITSTATUS=$(systemctl status $UNIT)

      curl http://localhost:8090/status -d "
      Status report for unit: $UNIT
      $EXTRA

      $UNITSTATUS
      "    
      '';
    in {
      systemd.services = {
        "unit-status@" = {
          description = "Send status report for failed service %i";
          path = with pkgs; [ systemd curl ];

          serviceConfig.ExecStart = "${unit_status}/bin/unit_status %I 'Host: %H'";
          after = [ "network.target" ];
        };

        "allways-fails" = {
          script = "exit -1";
          onFailure = [ "unit-status@%n.service" ];
        };
      }; 
    };
}
