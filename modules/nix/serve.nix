{
  flake.modules.nixos.serve_cache = { config, ... }: {
    nix.settings = {
      substituters = [
        "https://cache.local"
        "https://cache.stroby.org"
      ];

      trusted-public-keys = [
        "asus-stroby:d2r+MIkxb07Gu7OHRNN79ioz83AxBXFK3gvs6OQnRdw="
      ];
    }; 
  };
}
