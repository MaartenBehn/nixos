{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ filebrowser ];
  networking.firewall = {
    allowedTCPPorts = [ 
      8080
    ];
  };
}
