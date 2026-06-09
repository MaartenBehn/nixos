{
  flake.modules.homeManager.core = { pkgs, ... }: {
    home.packages = with pkgs; [
      (writeShellScriptBin "nix-clean" "sudo nix-collect-garbage --delete-older-than 5d && nix-store --optimise")
      (writeShellScriptBin "nix-store-size" "du -BM /nix/store/ | sort -n")
    ];
  };
}
