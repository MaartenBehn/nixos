{ self, ... }: {
  hosts.stroby-laptop = {
    nixos.imports = with self.modules.nixos; [
        framework
        fix_tpm2
        networking
        networking_vpn
        bluetooth
        battery
        syncthing
        fingerprint
        smb
        cli
        cli-full
        hyprland
        intel-graphics
        apps-minimal
        apps
        code
        projects_tauri
        postgres
        algo_trading
        games
        solaar
      ];

    homeManager = {
      imports = with self.modules.homeManager; [
        solaar
        cli
        cli-full
        hyprland
        battery-hyprland-notifications
        apps-minimal
        apps
        code
        solaar
      ];

      home.sessionVariables.terminal = "kitty";
    };
  };
}
