{
  flake.modules.nixos.server = {
    services.wger = {
      enable = true;
      domain = "wger.yourdomain.com";
      secretKeySecret = "wger_secret_key"; # Matches your sops secret entry
      timeZone = "Europe/Berlin";
    };
  };
}
