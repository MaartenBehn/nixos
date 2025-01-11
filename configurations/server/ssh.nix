{ ... }: 
{
  services.openssh = {
    enable = true;
    # require public key authentication for better security
    settings.PasswordAuthentication = true;
    settings.KbdInteractiveAuthentication = false;
    #settings.PermitRootLogin = "yes";
  };
  users.users."stroby".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINCS9II0jDA+/O/i95y4nnBcWwGZOLCt86558YevN0lI stroby@desktop"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBVwGBVe0muTLGRPDlPMJ/MXAoQBPZrKl/41MHColUJW stroby@stroby-laptop"   
    # content of authorized_keys file
    # note: ssh-copy-id will add user@your-machine after the public key
    # but we can remove the "@your-machine" part
  ];
}
