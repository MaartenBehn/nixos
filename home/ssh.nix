{ ... }: {
 programs.ssh.enable = true;
  programs.ssh.matchBlocks = {
    ropelab = {
      hostname = "betelgeuse.uberspace.de";
      user = "ropelab";
    };
    behnserver = {
      hostname = "192.168.178.39";
      user = "Stroby";
    };

    asus = {
      hostname = "192.168.178.23";
      user = "stroby";
    };
  }; 
}
