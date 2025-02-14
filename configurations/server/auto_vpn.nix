{ pkgs, ... }: {
  systemd.services.auto_vpn = {
    wantedBy = [ "multi-user.target" ];
		after = [ "network.target" ];

    path = with pkgs; [
      bash
      curl
    ];
		
    script = "sh /home/stroby/nixos/scripts/vpn_to_behns.sh";
  };

}
