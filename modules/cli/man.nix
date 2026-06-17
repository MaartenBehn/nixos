{
  flake.modules.nixos.cli-full = {
    documentation.nixos.enable = true;
    documentation.man.generateCaches = true;
  };

  flake.modules.homeManager.cli-full = { pkgs, ... }: {
    home.packages = (with pkgs; [    
      tldr                              # Better man
      man-pages       
    ]);
  };
}
