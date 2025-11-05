{ ... }: 
let
  totalMem = 16384;
  sharedBuffers = toString (totalMem / 4) + "MB";
  workMem = "16MB";
  maintenanceWorkMem = "128MB";
  effectiveCacheSize = toString (totalMem / 2) + "MB";
in {

  services.postgresql = {
    enable = true;
    authentication = ''
    #...
    #type database DBuser origin-address auth-method
    local all       all     trust
    # ipv4
    host  all      all     127.0.0.1/32   trust
    # ipv6
    host all       all     ::1/128        trust
    '';
    enableTCPIP = true;
    settings = {
      port = 5432;
      max_connections = 100;
      shared_buffers = sharedBuffers;
      work_mem = workMem;
      maintenance_work_mem = maintenanceWorkMem;
      effective_cache_size = effectiveCacheSize;
      wal_level = "replica";
      synchronous_commit = "off";
      checkpoint_completion_target = 0.9;
      checkpoint_timeout = "15min";
      max_worker_processes = 4;
      max_parallel_workers_per_gather = 2;
      autovacuum = "on";
      autovacuum_vacuum_scale_factor = 0.05;
      autovacuum_analyze_scale_factor = 0.02;
    };
  };

}
