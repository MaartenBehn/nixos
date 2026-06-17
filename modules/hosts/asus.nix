{ self, ... }: {
  hosts.stroby-asus = {
    nixos.imports = with self.modules.nixos; [
      keep_on_with_closed_lid
      networking
      battery
      battery-server-notifications
      server
      cli
      cli-full
    ];

    homeManager.imports = with self.modules.homeManager; [
      cli
      cli-full
    ];
  };
}
