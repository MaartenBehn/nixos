{ inputs, system, username, ... }: {
  imports = [ 
    inputs.agenix.nixosModules.default
  ];

  environment.systemPackages = [ 
    inputs.agenix.packages.${system}.default 
  ];

  identityPaths = [ "/home/${username}/.ssh/id_ed25519" ];

  age.secrets.mullvad.file = ../secrets/mullvad.conf;
}
