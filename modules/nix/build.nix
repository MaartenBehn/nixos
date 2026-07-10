{
  flake.modules.homeManager.core = { pkgs, ...}: 
    let
      nix-rebuild = pkgs.writeShellScriptBin "nix-rebuild" ''
        cd /home/$USER/nixos/
        git add --all
        sudo nixos-rebuild switch --flake . --impure 
        cd -
      '';

      nix-rebuild-pull = pkgs.writeShellScriptBin "nix-rebuild-pull" ''
        cd /home/$USER/nixos/
        git pull
        sudo nixos-rebuild switch --flake . --impure 
        cd -
      '';

      nix-rebuild-pretty = pkgs.writeShellScriptBin "nix-rebuild" ''
        cd /home/$USER/nixos/
        git add --all
        nh switch . -- --impure 
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
        nix-update
        nh
        nix-prefetch-github

        git
      ];
    };
}
