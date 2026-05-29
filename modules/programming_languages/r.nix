{
  /*
  flake.modules.homeManager.code = { pkgs, ... }: 
    let
      R-with-packages = pkgs.rWrapper.override{ packages = with pkgs.rPackages; [ ]; };
      RStudio-with-packages = pkgs.rstudioWrapper.override{ packages = with pkgs.rPackages; [ ]; };
    in
      {
      home.packages = [
        R-with-packages
        RStudio-with-packages
      ];
    };
  */
}
