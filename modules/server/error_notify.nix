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

          serviceConfig.ExecStart = "${unit_status}/bin/unit_status %I 'Hostname: %H' 'Machine ID: %m' 'Boot ID: %b'";
          after = [ "network.target" ];
        };

        "allways-fails" = {
          script = "exit -1";
          onFailure = [ "unit-status@%n.service" ];
        };

        # Automatically attach OnFailure=unit-status@%n.service to ALL systemd services
      } // (lib.mapAttrs (name: service: {
          # Do not attach the handler to itself or template instances to prevent infinite loops
          onFailure = lib.mkIf (name != "unit-status@" && !(lib.hasPrefix "unit-status@" name)) [
            "unit-status@%n.service"
          ];
        }) {});
    };
}
