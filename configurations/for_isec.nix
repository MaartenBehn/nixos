{ ... }:
{
  imports = [
    "./gnupg.nix"
  ];

  # Open port for revshell
  networking.firewall = {
    allowedTCPPorts = [ 9001 ];
  };
}
