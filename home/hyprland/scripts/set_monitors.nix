{ pkgs, ... }: 
let 
  script = pkgs.writeShellScriptBin "set-monitors" (
    builtins.readFile ./set-monitors.sh
  );

 in {
  home.packages = (with pkgs; [
    script
  ]);
}
