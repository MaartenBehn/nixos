{ self, ... }: {

  my.secrets.iso."iso_stroby_ssh_private_key" = {
    bitwarden = { name = "Iso"; field = "private_key"; };
    path = "/home/stroby/.ssh/id_ed25519";
    owner = "stroby";
  };

  my.secrets.iso."iso_stroby_ssh_key_public_key" = {
    bitwarden = { name = "Iso"; field = "public_key"; };
    path = "/home/stroby/.ssh/id_ed25519.pub";
    owner = "stroby";
  };

  flake.modules.nixos.core = {
    users.users."stroby".openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBi3jcEu+fWpDcaRndwRZrg0LVtXSaCFhxcyS4AIHOOJ stroby@nixos"
    ];
  };

  flake.modules.nixos.iso = { modulesPath, pkgs, lib, config, ... }: {
    imports = [
      "${toString modulesPath}/installer/cd-dvd/installation-cd-base.nix"
    ];

    boot.kernelPackages = lib.mkForce pkgs.linuxPackages;

    # Override core settings not applicable to an ISO installer image
    boot.loader.systemd-boot.enable = lib.mkForce false;
    boot.loader.efi.canTouchEfiVariables = lib.mkForce false;

    # Autologin as the configured user
    services.displayManager.autoLogin = {
      enable = true;
      user = config.username;
    };
    services.getty.autologinUser = lib.mkForce config.username;

    # Make sure wheel user can use sudo without password on live ISO
    security.sudo.wheelNeedsPassword = false;
  };

  flake.modules.homeManager.iso = {
    home.sessionVariables.terminal = "kitty";
  };

  hosts.iso = {
    modules = [
      "core"
      "iso"
      "networking"
      "bluetooth"
      "battery"
      "cli"
      "hyprland"
      "apps-minimal"
    ];

    local_ip = "127.0.0.1";
  };

  perSystem = { self', pkgs, ... }: {
    packages.iso = self.nixosConfigurations.iso.config.system.build.isoImage;
  };
}
