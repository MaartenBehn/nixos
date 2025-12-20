{ pkgs, lib, ... }:
let
  nvtop = pkgs.nvtopPackages.intel.overrideAttrs (old: {
    version = "fix-2"; # usually harmless to omit    
    src = pkgs.fetchFromGitHub {
      owner = "MaartenBehn";
      repo = "nvtop";
      rev = "d1bdff3a4adc5f8463070a20e225a767094106d1";
      hash = "sha256-toFCGzA56pHVvjxRpCGXsRPJS7QicdVFAGtmWnt6fGc=";
    };
  });

in { 
  home.packages = [ 
    pkgs.nvtopPackages.intel
    pkgs.intel-gpu-tools
  ];
}
