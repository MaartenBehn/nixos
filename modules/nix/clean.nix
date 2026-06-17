{
  flake.modules.nixos.core = {
    nix.optimise.automatic = true;
    nix.settings.auto-optimise-store = true;
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 5d";
    };
  };

  flake.modules.homeManager.core = { pkgs, ... }: {
    home.packages = with pkgs; [
      (writeShellScriptBin "nix-clean" "sudo nix-collect-garbage --delete-older-than 5d && nix-store --optimise")
      (writeShellScriptBin "nix-store-size" "du -BM /nix/store/ | sort -n")
    ];
  };
}
