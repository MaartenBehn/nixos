{ inputs, ... }: {
  flake.modules.nixos.core = { config, ... }: {
    imports = [ 
      inputs.sops-nix.nixosModules.sops
    ];

    sops.defaultSopsFile = ../../.sops.secretspec.yaml;
    sops.defaultSopsFormat = "yaml";

    sops.age.keyFile = "/home/${config.username}/.config/sops/age/keys.txt";
  };

  flake.modules.homeManager.core = { pkgs, config, ... }: {
    home.packages = with pkgs; [
      secretspec
      bitwarden-cli
    ];

    home.file = {  
      "/home/${config.username}/.config/secretspec/config.toml" = { 
        force = true;
        text = ''
          [defaults]
          provider = "bw"
          profile = "default"
        ''; 
        executable = false; 
      };
    };
  };
}
