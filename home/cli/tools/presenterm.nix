{ pkgs, ... }: {
  home.packages = with pkgs; [ 
    presenterm
    python312Packages.weasyprint
  ];
}
