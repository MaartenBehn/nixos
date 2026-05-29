{
  flake.modules.homeManager.cli = { pkgs, pkgs-2505, config, ... }: {
    home.packages = if config.host == "stroby-laptop" then 
      [ pkgs.nvtopPackages.intel ]
    else 
      [ pkgs-2505.nvtopPackages.nvidia ];
  };
}
