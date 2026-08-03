{ inputs, ... }: {
  flake.modules.nixos.core = { config, ... }: {
    imports = [ 
      inputs.sops-nix.nixosModules.sops
    ];

    sops.defaultSopsFile = ../../secrets/secrets.yaml;
    sops.defaultSopsFormat = "yaml";

    sops.age.keyFile = "/home/${config.username}/.config/sops/age/keys.txt";
  };
}
