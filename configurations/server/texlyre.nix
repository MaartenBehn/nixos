{ pkgs, ... }: 
let
   valid_check = pkgs.writeShellScriptBin "valid_check" ''
    if [ ! -d "/srv/texlyre" ]; then
      cd /srv 
      git clone https://github.com/MaartenBehn/texlyre.git texlyre
      chown -R texlyre:nginx /srv/texlyre
    fi
  '';

  build = pkgs.writeShellScriptBin "build" ''
    cd /srv/texlyre
    npm install
    npm run build:prod
  '';
in {

  users.users.texlyre = {
    isNormalUser = true;
    group = "nginx";
  };

  systemd.services.texlyre-valid = {
    path = with pkgs; [
      git
      valid_check
    ];
    script = "valid_check";
  };

  systemd.services.texlyre-build = {
    path = with pkgs; [
      nodejs
      bash
      build
    ];
    script = "build";
    serviceConfig.User = "texlyre";
  };
  
  web_services."texlyre" = {
    domains = "all";
    loc = {
      root = "/srv/texlyre/dist";
      extraConfig = '' 
        try_files $uri $uri.html /index.html =404;
      '';
    };
  };
}
