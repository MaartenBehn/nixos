# Commands:
# - nix-locate
# - , <any not installed programm>
# - nix-search 
# - nix-search-local 

{ inputs, ... }: {
  flake.modules.homeManager.core = { pkgs, ... }: {
    imports = [ inputs.nix-index-database.homeModules.default ];

    programs.nix-index.enable = true;
    programs.command-not-found.enable = false;
    programs.nix-index-database.comma.enable = true;

    home.packages = with pkgs; [
      nix-search-cli
      (writeShellScriptBin "nix-search-local" "fd /nix")
      fd
    ];
  };
}
