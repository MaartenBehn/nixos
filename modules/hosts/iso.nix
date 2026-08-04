{ self, ... }: {
  flake.modules.nixos.iso = { modulesPath, pkgs, lib, ... }: {
    imports = [
      "${toString modulesPath}/installer/cd-dvd/installation-cd-base.nix"
    ]; 

    boot.kernelPackages = lib.mkForce pkgs.linuxPackages;
  };

  hosts.iso = {
    nixos = {
      imports = with self.modules.nixos; [
        iso
        networking
        networking_vpn
        bluetooth
        battery
        cli
        hyprland
        apps-minimal
      ];

      username = "nixos";
    };

    homeManager = {
      imports = with self.modules.homeManager; [
        solaar
        cli
        hyprland
        battery-hyprland-notifications
        apps-minimal
      ];

      home.sessionVariables.terminal = "kitty";
    };
  };

  # Expose a direct shortcut package
  perSystem = { self', pkgs, ... }: {
    packages.iso = self.nixosConfigurations.iso.config.system.build.isoImage;
  };
}
