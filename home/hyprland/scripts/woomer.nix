{pkgs, pkgs-unstable, ... }: 
let
  script = pkgs.writeShellScriptBin "woomer-current" ''
    #!/usr/bin/env bash

    woomer --monitor $(hyprctl activeworkspace -j | jq -r .monitor)
  ''; 
in {
  home.packages = [ 
    pkgs-unstable.woomer
    script 
  ];
}
