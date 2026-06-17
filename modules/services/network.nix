{
  flake.modules.nixos.core = { config , ...}: {
    networking.hostName = config.host;
  };

  flake.modules.nixos.networking = { config, ... }: {
    networking = {
      networkmanager.enable = true;
      nameservers = [
        "8.8.8.8"
        "8.8.4.4"
        "1.1.1.1"
        "208.67.222.222" # open DNS
        "208.67.220.220" # open DNS
      ];
      firewall = {
        enable = true;
      };
    };

    users.users."${config.username}" = {
      isNormalUser = true;

      extraGroups = [
        "networkmanager"
      ];
    };

    services.gnome.gnome-keyring.enable = true;
    #security.pam.services.sddm.enableGnomeKeyring = true;
  };
}
