{
  flake.modules.homeManager.full = { pkgs, ... }: {
    home.packages = with pkgs; [ 
      presenterm
      python312Packages.weasyprint
    ];
  };
}
