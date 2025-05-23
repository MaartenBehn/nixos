{ pkgs, ... }: 

with pkgs;
let
  R-with-packages = rWrapper.override{ packages = with rPackages; [ ]; };
  RStudio-with-packages = rstudioWrapper.override{ packages = with rPackages; [ ]; };
in
{
  home.packages = [
    R-with-packages
    RStudio-with-packages
  ];
}
