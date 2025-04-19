{ desktop, ... }:
{
  services.desktopManager.plasma6.enable = (desktop == "plasma6");
  services.xserver.desktopManager.plasma5.enable = (desktop == "plasma5");
}
