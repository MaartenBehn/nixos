{ pkgs, config, ... }: 
let
  db_user = "lunauser";
  password = "MoondGarden55!";
  db_name = "lunadblocal";

  init_script = pkgs.writeText "backend-initScript" ''
      DO $$ 
      BEGIN
        IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '${db_user}') THEN
          CREATE ROLE ${db_user} WITH LOGIN PASSWORD '${password}';
        ELSE
          ALTER ROLE ${db_user} WITH PASSWORD '${password}';
        END IF;
      END
      $$;

      CREATE DATABASE ${db_name} OWNER ${db_user};
      GRANT ALL PRIVILEGES ON DATABASE ${db_name} TO ${db_user};
  ''; 
in {
  imports = [ ./server/postgres.nix ];

  services.postgresql = {
    enable = true;
  };

  systemd.services."postgresql-${db_user}-setup" = {
    serviceConfig = {                 
      Type = "oneshot";
      User = "postgres";            
    }; 
    wantedBy = [ "default.target" ];                       
    after = [ "postgresql.service" ];                                                                                                                     
    path = [ config.services.postgresql.package ];                                                                                                
    script = "psql --file ${init_script}";                            
  };
}
