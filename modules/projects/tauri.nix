{
  flake.modules.nixos.projects_tauri = {
    networking.firewall.allowedTCPPorts = [ 1420 ]; 
  };
}
