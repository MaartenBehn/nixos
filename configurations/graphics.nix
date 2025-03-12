{pkgs, ...}: {
  # Enable Graphics
  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [
    mesa
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
    intel-media-driver
  ];

}
