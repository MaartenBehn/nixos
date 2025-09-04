{ inputs, system, ... }: {
  imports = [ 
    inputs.agenix.nixosModules.default
  ];

  environment.systemPackages = [ 
    inputs.agenix.packages.${system}.default 
  ];

  age.secrets.mullvad.conf.file = ../secrets/mullvad.conf;
}
