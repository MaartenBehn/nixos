{
  flake.modules.homeManager.core = { pkgs, ...}: 
    let
      nix-rebuild = pkgs.writeShellScriptBin "nix-rebuild-pretty" ''
        cd /home/$USER/nixos/
        git add --all
        nh os switch --quiet --impure --keep-going .
        cd -
      '';

      nix-rebuild-pull = pkgs.writeShellScriptBin "nix-rebuild-pretty-pull" ''
        cd /home/$USER/nixos/
        git pull
        nh os switch --quiet --impure --keep-going .
        cd -
      '';

      nix-update = pkgs.writeShellScriptBin "nix-update" ''
        cd /home/$USER/nixos/ 
        git add --all 
        nix flake update 
        cd -
      '';
    in {
      home.packages = with pkgs; [
        nix-rebuild 
        nix-rebuild-pull
        nix-rebuild-pretty
        nix-rebuild-pretty-pull
        nix-update
        nh
        nix-output-monitor
        nix-prefetch-github
        nix-weather

        git
      ];
    };
}
