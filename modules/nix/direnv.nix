{
  flake.modules.homeManager.core = { pkgs, config, lib, ... }: 
    let 
      init-shell = pkgs.writeShellScriptBin "init-shell" ''
        rm .envrc || true 
        echo 'use nix' >> .envrc && direnv allow      
      '';

      init-devshell = pkgs.writeShellScriptBin "init-devshell" ''
        rm -f .envrc
        INPUT_NAME=''${1:-nixpkgs}
        SYS_REV=$(nix flake metadata "$FLAKE_PATH" --json | ${lib.getExe pkgs.jq} -r '.locks.nodes.nixpkgs.locked.rev')
        echo "use flake . --override-input $INPUT_NAME nixpkgs/$SYS_REV" >> .envrc
        direnv allow      
      ''; 

    in {
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
        silent = true;
      };

      home.sessionVariables = {
        FLAKE_PATH = "${config.home.homeDirectory}/nixos";       
      };

      home.packages = [
        init-shell      
        init-devshell     
      ];
    };
}
