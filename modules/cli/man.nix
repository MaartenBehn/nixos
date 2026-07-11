{
  flake.modules.nixos.core = {
    documentation.nixos.enable = false;
    documentation.man.generateCaches = false;
  };

  flake.modules.homeManager.core = {
    programs.man.generateCaches = false;
  };

  flake.modules.nixos.cli-full = { pkgs, ... }: {
  };  

  flake.modules.homeManager.cli-full = { pkgs, ... }: {
    home.packages = (with pkgs; [    
      #tldr                              # Better man
      #man-pages       
    ]);
  };
}
