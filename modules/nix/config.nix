{
  flake.modules.homeManager.core = { pkgs, ...}: 
    let
      nix-config = pkgs.writeShellScriptBin "nix-config" ''
        cd ~/nixos 
        nvim . 
        cd - 
      '';

      secrets-config = pkgs.writeShellScriptBin "secrets-config" ''
        cd ~/nixos/secrets
        sops secrets.yaml 
        cd - 
      '';

      secrets-key = pkgs.writeShellScriptBin "secrets-key" ''
        mkdir -p ~/.config/sops/age
        nvim ~/.config/sops/age/keys.txt 
      '';
    
    in {
      home.packages = with pkgs; [
        nix-config
        secrets-config
        secrets-key

        sops
      ];
    };
}
