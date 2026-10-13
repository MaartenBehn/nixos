{ inputs, ... }: {
  flake.modules.homeManager.cli-full = { config, ... }: {
    home.packages = [ inputs.agy-nix.packages.${config.system_type}.antigravity-cli ];
  };
}


