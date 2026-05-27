{
  flake.modules.homeManager.core = { pkgs, ... }: 
    let 
      nix-shell-init = pkgs.writeShellScriptBin "nix-shell-init" ''
        rm .envrc || true 
        echo 'use nix' >> .envrc && direnv allow      
      '';

      nix-devshell-init = pkgs.writeShellScriptBin "nix-devshell-init" ''
        rm .envrc || true 
        echo 'use flake' >> .envrc && direnv allow      
      ''; 

    in {
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
        silent = true;
      };

      home.packages = [
        nix-shell-init      
        nix-devshell-init      
      ];

      home.shellAliases = {
        init-nix-shell="nix-shell-init";
        init-shell="nix-shell-init";
        load-shell="direnv reload";
      };
    };
}
