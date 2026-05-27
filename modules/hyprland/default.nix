{
  flake.modules.homeManager.hyprland = { pkgs, ... }: {
    home.packages = (with pkgs; [
      wl-clipboard                      # clipboard utils for wayland (wl-copy, wl-paste)
      pavucontrol                       # pulseaudio volume controle (GUI)
      swappy                            # snapshot editing tool
      python3

      killall

      swww
      #inputs.hypr-contrib.packages.${pkgs.system}.grimblast
      grimblast
      hyprpicker
      #inputs.hyprmag.packages.${pkgs.system}.hyprmag
      #hyprmag
      grim
      slurp
      wl-clip-persist
      cliphist
      wf-recorder
      glib
      wayland

      networkmanagerapplet
      seahorse
      blueberry
      btop
      poweralertd                       # Battery notifications
    ]);
  };
}
