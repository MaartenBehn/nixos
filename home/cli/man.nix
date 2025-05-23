{ pkgs, ... }: {
  home.packages = (with pkgs; [    
    tldr                              # Better man
    man-pages       
  ]);
}
