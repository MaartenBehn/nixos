{
  flake.modules.homeManager."stroby-laptop" = { pkgs, ... }: {
    home.packages = [ pkgs.nvtopPackages.intel ];
  };

  flake.modules.homeManager."stroby-desktop" = { pkgs-2505, ... }: {
    home.packages = [ pkgs-2505.nvtopPackages.nvidia ];
  };
}
