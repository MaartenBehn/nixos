# Lcdit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, system, lib, ... }:

{   
  imports = [ 
    ./hardware-configuration.nix 
    ./steam.nix
    ./syncthing.nix
  ];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  # --- USER ----
  networking.hostName = "stroby-nixos"; # Define your hostname.

   users.users.stroby = {
    isNormalUser = true;
    description = "stroby";
    extraGroups = [ "networkmanager" "wheel" ];
  };
  users.defaultUserShell = pkgs.fish;
  system.stateVersion = "23.11";

  # --- LOCAL ---
  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties. 
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Configure console keymap
  console.keyMap = "de";

  

  # --- HARDWARE FEATURES ---
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = false; # powers up the default Bluetooth controller on boot

  services.thermald.enable = true;

  hardware.opengl.extraPackages = with pkgs; [
    mesa_drivers
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
    intel-media-driver
  ];

  # Audio
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  # rtkit is optional but recommended
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.fprintd.enable = true;
  
  
  # --- DESKTOP ----
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  # Fonts
  # https://nixos.wiki/wiki/Fonts
  fonts = {
    fontDir.enable = true;
    packages = with pkgs;[
      noto-fonts-cjk   # Beautiful and free fonts for CJK languages
      noto-fonts-emoji # Color and Black-and-White emoji fonts
      nerdfonts
    ];
  };


  # --- PROGRAMS ---
  nixpkgs = {
    # Allow unfree packages
    config.allowUnfree = true;
  };

  environment.systemPackages = with pkgs; [
    
    # fish shell
    fish
    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.forgit
    fishPlugins.hydro
    fzf
    fishPlugins.grc
    grc
    dwt1-shell-color-scripts
    starship

    direnv
    any-nix-shell

    # NeoVim
    # lazygit
    # xclip
    # neovim
    
    # for open nix config shortcut
    # wmctrl

    eza
    btop
    yakuake
    git
    # alacritty
    fd
    unzip
    wget
    python3
    
    # Netowork stuff
    gnirehtet
    openconnect

    # Big Apps
    firefox
    thunderbird
    obsidian
    discord
    kate
    
    # jetbrains
    jetbrains.webstorm
    jetbrains.pycharm-professional
    jetbrains.clion
    jetbrains.idea-ultimate


    wineWowPackages.stable
    winetricks

  ];
  programs.fish.enable = true;
   
   environment.variables = {
    PKG_CONFIG_PATH = with pkgs; lib.makeLibraryPath [
      fontconfig
    ];
    EDITOR = "nvim";
  };

}

