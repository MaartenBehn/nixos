{pkgs, pkgs-unstable, ... }: 
let
  script = pkgs.writeShellScriptBin "woomer-current" ''
    #!/usr/bin/env bash

    ${pkgs-unstable.woomer} --monitor (hyprctl activeworkspace -j | jq -r .monitor)
  ''; 
in {
  home.packages = [ script ];
}
