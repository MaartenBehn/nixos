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

    my.secrets.cli-full_."avante_nvim_gemini_api_key" = { 
      bitwarden = { name = "Gemini"; field = "API Key"; };
      owner = "stroby"; 
    };

    flake.modules.homeManager.cli = { system, pkgs, ... }: {
      home.packages = with pkgs; [
        (mkNixvim system pkgs)
        xclip
        lazygit
        lldb
        prettier
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
