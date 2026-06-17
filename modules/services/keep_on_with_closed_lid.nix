{
  flake.modules.nixos.keep_on_with_closed_lid = {
    services.logind.settings.Login.HandleLidSwitch = "ignore";
  };
}
