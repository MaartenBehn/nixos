{
  flake.modules.homeManager.full-cli = { pkgs, ... }: {
    home.packages = with pkgs; [ 
      presenterm
      python312Packages.weasyprint
    ];
  };
}
