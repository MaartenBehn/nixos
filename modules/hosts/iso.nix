{ self, modulesPath, ... }: {
  flake.modules.nixos.iso = {
    imports = [
      "${toString modulesPath}/installer/cd-dvd/installation-cd-base.nix"
    ];  
  };

  hosts.iso = {
    nixos.imports = with self.modules.nixos; [
      iso
      networking
      networking_vpn
      bluetooth
      battery
      cli
      hyprland
      apps-minimal
    ];

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
