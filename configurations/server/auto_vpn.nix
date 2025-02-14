{ pkgs, ... }: {
  systemd.services.terraria-server-6tunnel = {
    wantedBy = [ "multi-user.target" ];
		after = [ "network.target" ];

    path = [
      pkgs.bash
    ];
		
    script = "sh /home/stroby/nixos/scripts/vpn_to_behns.sh";
  };

}
