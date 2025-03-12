{ pkgs, ... }:
{
  # services.desktopManager.plasma6.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
 
  environment.systemPackages = with pkgs; [
    # System Tools
    kdePackages.partitionmanager
    qdirstat

    # Console emulator
    alacritty

    # Netowork stuff      
    networkmanager
  
    firefox

    python3
  ];  
}
