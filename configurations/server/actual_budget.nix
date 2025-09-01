{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.actual-server
  ];

  systemd.services.filebrowser = {
    path = with pkgs; [
      actual-server
    ];
      #script = "actual-server";
    wantedBy = [ "network-online.target" ];
		after = [ "network.target" ];
  };
}
