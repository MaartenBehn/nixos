{ pkgs, domains, local_domain, ... }: 
let
   valid_check = pkgs.writeShellScriptBin "valid_check" ''
    if [ ! -d "/srv/mmdl" ]; then
      cd /srv 
      git clone https://github.com/intri-in/manage-my-damn-life-nextjs.git mmdl
      chown -R mmdl:nginx /srv/mmdl
    fi
  '';

  init = pkgs.writeShellScriptBin "init" ''
    cd /srv/mmdl
    npm install

    cat <<EOF >.env.local
############################################################
## The following variables NEED to be set before execution.
############################################################

## Database variables.
DB_HOST=mmdl
DB_USER=mmdl
DB_PASS=1234
DB_PORT=5432
# DB_DIALECT can be one of the following:'mysql' | 'postgres' | 'sqlite'. See documentation for more details. 
DB_DIALECT=postgres
DB_NAME=install_mmdl
DB_CHARSET=utf8mb4
DB_COLLATE=utf8mb4_0900_ai_ci

## AES Encryption Password
## This is used to encrypt CalDAV passwords in the database.

AES_PASSWORD=1234

############################################################
## The following variables aren't required for basic functionality,
## but might be required to be set for some additional features.
############################################################

## SMTP Settings
SMTP_HOST=host
SMTP_USERNAME=username
SMTP_PASSWORD=password
SMTP_FROMEMAIL=test@example.com
SMTP_PORT=25
SMTP_USESECURE=false 

## Enable NextAuth.js for third party authentication. It's highly recommended that you use a third party authentication service. Please note that third party authentication will eventually become the default option in the future versions of MMDL (probably by v1.0.0).

# The following variable's name has changed in v0.4.1
USE_NEXT_AUTH=false

# This is a variable used by NextAuth.js. This must be same as your domain.
NEXTAUTH_URL=http://localhost:3000/

# This is a variable used by NextAuth.js. Must be generated.
# https://next-auth.js.org/configuration/options#nextauth_secret
NEXTAUTH_SECRET=REALLY_SUPER_STRONG_SECRET_KEY

##  Refer to docs for guide to set following variables. Ignore if USE_NEXT_AUTH is set to false. Uncomment as required.

# KEYCLOAK_ISSUER_URL=http://localhost:8080/realms/MMDL
# KEYCLOAK_CLIENT_ID=mmdl-front-end
# KEYCLOAK_CLIENT_SECRET=SAMPLE_CLIENT_SECRET

# GOOGLE_CLIENT_ID=
# GOOGLE_CLIENT_SECRET=

# AUTHENTIK_CLIENT_ID=
# AUTHENTIK_CLIENT_SECRET=
# AUTHENTIK_ISSUER=



############################################################
## The following variables aren't required to be set,
## but affect behaviour that you might want to customise.
############################################################

## Array of Valid Caldav Addresses
#ADDITIONAL_VALID_CALDAV_URL_LIST = ["http://testaddress", "http://testaddress2"]

# User Config
NEXT_PUBLIC_DISABLE_USER_REGISTRATION=false

# After this value, old ssid will be deleted.
MAX_CONCURRENT_LOGINS_ALLOWED=3

# Maxium length of OTP validity, in seconds.
MAX_OTP_VALIDITY=1800

# Maximum length of a login session in seconds.
MAX_SESSION_LENGTH=2592000

# Enforce max length of session.
ENFORCE_SESSION_TIMEOUT=true

############################################################
## The following variables are advanced settings,
## and must be only changed in case you're trying something
## specific.
############################################################

#Whether user is running install from a docker image.
DOCKER_INSTALL=false

## General Config
NEXT_PUBLIC_API_URL=http://localhost:3000/api

## Debug Mode
NEXT_PUBLIC_DEBUG_MODE=true
NEXT_API_DEBUG_MODE=true

#Max number of recursions for finding subtasks. Included so the recursive function doesn't go haywire.
#If subtasks are not being rendered properly, try increasing the value.
NEXT_PUBLIC_SUBTASK_RECURSION_CONTROL_VAR=100

## Test Mode
NEXT_PUBLIC_TEST_MODE=false
EOF

    npm run migrate
    npm run build
  '';

  mmdl = pkgs.writeShellScriptBin "mmdl" ''
    cd /srv/mmdl
    npm run start
    ''; 
in {

  # Set password for user to 1234
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

  services.postgresql = {
    enable = true;

    ensureDatabases = [ "mmdl" ];
    ensureUsers = [ 
      {
        name = "mmdl";
        ensureDBOwnership = true;
      }
    ];

    enableTCPIP = true;
    settings.port = 5432;
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
