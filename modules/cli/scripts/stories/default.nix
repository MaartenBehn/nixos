{ inputs, ... }: {
  perSystem = { pkgs, ... }: let
    craneLib = inputs.crane.mkLib pkgs;

    src = craneLib.cleanCargoSource ./.;

    cargoArtifacts = craneLib.buildDepsOnly {
      inherit src;
    };

    story-extractor = craneLib.buildPackage {
      inherit src cargoArtifacts;
      pname = "story-extractor";
      version = "0.1.0";
    };
  in{
    packages.story-extractor = story-extractor;
  };

  flake.modules.homeManager.cli = { pkgs, ... }: {
    home.packages = [ pkgs.story-extractor ];
  };
}
