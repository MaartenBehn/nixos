{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    filebrowser
  ];

}
