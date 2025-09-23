{ ... }: {
  programs.ssh = { 
    enable = true;
    matchBlocks = {
      ropelab = {
        hostname = "betelgeuse.uberspace.de";
        user = "ropelab";
      };
      behnserver = {
        hostname = "192.168.178.39";
        user = "Stroby";
      };

      asus = {
        hostname = "192.168.178.2";
        user = "stroby";
      };

      proxy = {
        hostname = "138.199.203.38";
        user = "root";
      };
    }; 
  };
}
