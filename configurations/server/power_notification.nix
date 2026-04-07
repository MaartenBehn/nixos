{ pkgs, ... }: {
  # configuration.nix
  services.poweralertd = {
    enable = true;
    extraConfig = ''
    LowBatteryPercent=50
    CriticalBatteryPercent=10
    LowBatteryCommand=curl http://localhost:8090/status -d "Server Power below 50%"
    CriticalBatteryCommand=curl http://localhost:8090/status -d "Server Power below 10%"
    '';
  };
}
