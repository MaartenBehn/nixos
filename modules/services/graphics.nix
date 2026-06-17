{
  flake.modules.nixos.intel-graphics = {pkgs, ...}: {
    hardware.graphics.enable = true;
    hardware.graphics.extraPackages = with pkgs; [
      mesa
      intel-vaapi-driver
      libva-vdpau-driver
      libvdpau-va-gl
      intel-media-driver
    ];
  };
}
