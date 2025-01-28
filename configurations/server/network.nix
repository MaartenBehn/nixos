{ pkgs, ... }:
{
  imports = [
    ./ssh.nix
    ./static_ip.nix
  ];
  
  networking.firewall.enable = true;
  networking.networkmanager.enable = true;

  # SSL 
  security.acme = {
    acceptTerms = true;
    email = "stroby241@gmail.com";
  };
}
