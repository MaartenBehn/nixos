{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # For telnet
    inetutils
    nmap
  ];

}
