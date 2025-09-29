{ pkgs, domains, local_domain, ... }: 
let
   valid_check = pkgs.writeShellScriptBin "valid_check" ''
    if [ ! -d "/srv/mmdl" ]; then
      cd /srv 
      git clone https://github.com/MaartenBehn/manage-my-damn-life-nextjs.git mmdl
      chown -R mmdl:nginx /srv/mmdl
    fi
  '';

  init = pkgs.writeShellScriptBin "init" ''
    cd /srv/mmdl
    npm install

    npm run migrate
    npm run build
  '';

  mmdl = pkgs.writeShellScriptBin "mmdl" ''
    cd /srv/mmdl
    npm run start
    ''; 
in {

  users.users.mmdl = {
    isNormalUser = true;
    group = "nginx";
  };

  systemd.services.mmdl-valid = {
    path = with pkgs; [
      git
      valid_check
    ];
    script = "valid_check";
  };

  systemd.services.mmdl-init = {
    path = with pkgs; [
      nodejs
      bash
      init
    ];
    script = "init";
    serviceConfig.User = "mmdl";
  };
 
  systemd.services.mmdl = {
    path = with pkgs; [
      nodejs
      bash
      mmdl
    ];
    script = "mmdl";
    wantedBy = [ "network-online.target" ];
    serviceConfig.User = "mmdl";
  };

  services.nginx.virtualHosts = builtins.listToAttrs (builtins.map (domain: {
    name = "calendar.${domain}"; 
    value = {
      enableACME = domain != local_domain;
      forceSSL = domain != local_domain;
      locations."/" = {
        proxyPass = "http://127.0.0.1:3000/"; 
      };

      serverAliases = [
        "www.calendar.${domain}"
      ];
    };
  }) (domains ++ [ local_domain ]));
}
