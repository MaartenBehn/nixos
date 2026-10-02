{
  flake.modules.nixos.core = { config, ... }: {
    nix.settings = {
      substituters = [
        "https://cache.stroby.org"
      ];

      trusted-public-keys = [
        "cache.stroby.org:ymFjFI7oUzWh7ath5CbIHLF/w/qvwsaBhtp7/WgUC/I="
      ];

      trusted-users = [ config.username ];
    }; 
  };
}
