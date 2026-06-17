{
  flake.modules.homeManager.apps = { pkgs, ... }: {
    home.packages = (with pkgs; [
      ausweisapp
    ]);
  };

  flake.modules.nixos.apps = { pkgs, ... }: {
    networking.firewall = {
      allowedTCPPorts = [
        24727
      ];
      allowedUDPPorts = [
        24727
      ];
    };
  };

}
