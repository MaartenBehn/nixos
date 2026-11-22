{ self, ... }: {
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
