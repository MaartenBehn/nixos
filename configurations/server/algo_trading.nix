{ config, pkgs, lib, ... }:
let 
  # Database connection info
  db_user = "algo_trading";
  db_host = "localhost";
  db_name = "marketdata";
  db_passwordFile = config.sops.secrets."algo_trading/marketdata_db/password".path;
in {
  
  imports = [ ./postgres.nix ];

  users.users.algo_trading = {
    isSystemUser = true;
    group = "algo_trading";
  };
  users.groups.algo_trading = {};

  sops.secrets."algo_trading/marketdata_db/password" = {
    owner = "algo_trading";
    group = "algo_trading";
  };

  sops.templates."algo_trading_init.sql" = {
    content = ''
      DO $$ 
      BEGIN
        IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '${db_user}') THEN
          CREATE ROLE ${db_user} WITH LOGIN PASSWORD '${config.sops.placeholder."algo_trading/marketdata_db/password"}';
        ELSE
          ALTER ROLE ${db_user} WITH PASSWORD '${config.sops.placeholder."algo_trading/marketdata_db/password"}';
        END IF;
      END
      $$;

      CREATE DATABASE ${db_name} OWNER ${db_user};
      GRANT ALL PRIVILEGES ON DATABASE ${db_name} TO ${db_user};
      \c ${db_name}
      CREATE EXTENSION IF NOT EXISTS timescaledb;
      GRANT USAGE ON SCHEMA public TO ${db_user};
      GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO ${db_user};
    '';
    owner = "postgres";
  };

  # PostgreSQL service configuration
  services.postgresql = {
    enable = true;
    extensions = [ pkgs.postgresql16Packages.timescaledb ];
    settings = {
      shared_preload_libraries = "timescaledb";
    };
  };

  systemd.services."postgresql-${db_name}-setup" = {
    serviceConfig = {                 
      Type = "oneshot";
      User = "postgres";            
    }; 
    wantedBy = [ "default.target" ];                       
    after = [ "postgresql.service" ];                                                                                                                     
    path = [ config.services.postgresql.package ];                                                                                                
    script = "psql --file ${config.sops.templates."algo_trading_init.sql".path}";                            
  };
}
