{ pkgs, ... }: 
let 
  script = pkgs.writeShellScriptBin "trigger_kitty" (
    builtins.readFile ./trigger_kitty.sh
  );

 in {
  home.packages = (with pkgs; [
    script
  ]);
}
