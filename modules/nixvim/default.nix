{ inputs, lib, config, ... }: let 
  mkNixvim = system: pkgs: inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule {
      inherit pkgs;
      module = config.nixvimConfig; 
    };

  in {
  options.nixvimConfig = lib.mkOption {
    type = lib.types.deferredModule;
    default = { };
  };

  config = {
    perSystem = { system, pkgs, ... }: {
      packages = {
        nvim = (mkNixvim system pkgs);
      };
    };

    flake.modules.nixos.cli-full = { config, ... }: {
      sops.secrets."avante_nvim/gemini_api_key" = { owner = config.username; };
    };

    flake.modules.homeManager.cli = { system, pkgs, ... }: {
      home.packages = with pkgs; [
        (mkNixvim system pkgs)
        xclip
        lazygit
        lldb
        nodePackages.prettier
        terraform
        cargo
        rustc
        shader-slang
        typst
      ];

      home.sessionVariables = {
        EDITOR = "nvim";
      };
    };
  };
}
