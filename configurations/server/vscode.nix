{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.openvscode-server
  ];
}
