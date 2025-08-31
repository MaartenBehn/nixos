{ pkgs, ... }: let
  wine_folder = /home/stroby/nixos/wine;
  wine_apps = [
    {
      name = "MagicaVoxel";
      working_dir = wine_folder + "/MagicaVoxel-0.99.7.1-win64";
      app = "MagicaVoxel.exe";  
    }
    {
      name = "raddbg";
      working_dir = wine_folder + "/raddbg";
      app = "raddbg.exe";  
    }
  ];

  make_wine = app: pkgs.writeShellScriptBin app.name ''
    cd ${app.working_dir}
    wine "${app.working_dir}/${app.app}"
    cd -
  '';

  make_desktop_entry = app: {
    name = app.name;
    value = {
      name = app.name;
      exec = "${make_wine app}/bin/${app.name}";
      terminal = false;
      type = "Application";
      categories = ["System"];
      mimeType = ["x-scheme-handler/${app.name}"];
    };
  };
in {
  home.packages = builtins.map make_wine wine_apps;
  xdg.desktopEntries = builtins.listToAttrs (builtins.map make_desktop_entry wine_apps);
}
