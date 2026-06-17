{
  flake.modules.nixos.server-debug = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      # For telnet
      inetutils
      nmap
    ];
  };
}
