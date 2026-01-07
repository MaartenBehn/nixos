{ pkgs, ... }: 
let
   valid_check = pkgs.writeShellScriptBin "valid_check" ''
    if [ ! -d "/srv/texlyre" ]; then
      cd /srv 
      git clone https://github.com/TeXlyre/texlyre.git texlyre
      chown -R texlyre:nginx /srv/texlyre
    fi
  '';

  init = pkgs.writeShellScriptBin "init" ''
    cd /srv/texlyre
    npm install
  '';

  run = pkgs.writeShellScriptBin "run" ''
    cd /srv/texlyre
    npm run start
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

  systemd.services.texlyre-init = {
    path = with pkgs; [
      nodejs
      bash
      init
    ];
    script = "init";
    serviceConfig.User = "texlyre";
  };
 
  systemd.services.texlyre = {
    path = with pkgs; [
      nodejs
      bash
      run
    ];
    script = "run";
    wantedBy = [ "network-online.target" ];
    serviceConfig.User = "texlyre";
  };

  web_services."texlyre" = {
    domains = "all";
    loc = {
      proxyPass = "http://localhost:4173/texlyre/";
    };
  };
}
