{
  flake.modules.homeManager.core = { pkgs, ... }: {
    home.packages = (with pkgs; [    
      tldr                              # Better man
      man-pages       
    ]);
  };
}
