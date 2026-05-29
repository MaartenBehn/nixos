{
  flake.modules.homeManager.cli-full = { pkgs, ... }: {
    home.packages = (with pkgs; [    
      tldr                              # Better man
      man-pages       
    ]);
  };
}
