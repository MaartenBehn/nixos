{
  flake.modules.homeManager.hyprland = {pkgs, ... }: 
    let
      script = pkgs.writeShellScriptBin "woomer-current" ''
        woomer --monitor $(hyprctl activeworkspace -j | jq -r .monitor)
      ''; 
    in {
      home.packages = [ 
        pkgs.woomer
        script 
      ];
    };
}
