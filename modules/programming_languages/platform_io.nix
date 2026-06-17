{
  flake.modules.nixos.code = { pkgs, config, ... }: {
    services.udev.packages = with pkgs; [ platformio-core.udev ];

    users.users."${config.username}" = {
      extraGroups = [ "dialout" ];
    };
  };
}
