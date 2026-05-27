{ inputs, ... }: {
  flake.modules.homeManager.core = { system, ... }: {
    home.packages = [
      inputs.nix-inspect.packages."${system}".default
    ];
  }; 
}
