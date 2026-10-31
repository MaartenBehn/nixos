{
  flake.modules.homeManager.core = { pkgs, ... }: {
    home.packages = with pkgs; [
      bitwarden-cli
    ];

    home.activation.configureBitwardenCli = ''
      ${pkgs.bitwarden-cli}/bin/bw config server https://vaultwarden.stroby.org --quiet || true
    '';
  };
}
