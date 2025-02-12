{ pkgs, ... }:
{
  imports = [
    ./apps.nix
    ./shell/fish.nix
    ./shell/nixvim.nix
    ./shell/tmux.nix
    
  ]; 

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.libinput.enable = true;
  services.displayManager.sddm.enable = true;

  # services.desktopManager.plasma6.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  environment.systemPackages = with pkgs; [
    # System Tools
    kdePackages.partitionmanager
    qdirstat

    # Console emulator
    alacritty

    # Netowork stuff      
    networkmanager
  
    python3
  ];
  
  networking.firewall.enable = true;
}
