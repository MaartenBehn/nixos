{
  flake.modules.nixos.core = {
    documentation.nixos.enable = false;
    documentation.man.generateCaches = false;
  };

  flake.modules.homeManager.core = {
    programs.man.generateCaches = false;
  };

  flake.modules.nixos.cli-full = { pkgs, lib, ... }: {
    documentation.nixos.enable = lib.mkForce true;
    documentation.man.generateCaches = lib.mkForce true;
  };  

  flake.modules.homeManager.cli-full = { pkgs, lib, ... }: {
    programs.man.generateCaches = lib.mkForce true;
    home.packages = (with pkgs; [    
      man-pages     
      bat
    ]);

    home.sessionVariables = {
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    };

    programs.tealdeer = {
      enable = true;

      autoUpdate = true;

      settings = {
        updates = {
          auto_update_interval_hours = 168; # Update cache weekly (in hours)
        };
        display = {
          compact = false;
          use_code_format = true;
        };
      };
    };
  };
}
