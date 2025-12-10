{pkgs, ...}: {
  # Enable Graphics
  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [
    mesa
    intel-vaapi-driver
    libva-vdpau-driver
    libvdpau-va-gl
    intel-media-driver
  ];

}
