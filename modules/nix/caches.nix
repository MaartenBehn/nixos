{
  flake.modules.nixos.core = { config, ... }: {
    nix.settings = {
      substituters = [
        "https://cache.stroby.org"
        "https://nix-community.cachix.org"
        "https://nix-gaming.cachix.org"
        "https://cache.nixos-cuda.org"
        "https://chaotic-nyx.cachix.org"
      ];

      trusted-public-keys = [
        "cache.stroby.org:ymFjFI7oUzWh7ath5CbIHLF/w/qvwsaBhtp7/WgUC/I="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      ];

      trusted-users = [ config.username ];
    }; 
  };
}
