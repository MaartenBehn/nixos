{ inputs, pkgs, ... }: 

let 
  clip-latex = pkgs.writeShellScriptBin "clip-latex" ''
    screenshot --copy && echo "" | pix2tex | sed 's/.*)\.//g' | xclip -sel clip
    '';
in {
  home.packages = with pkgs; [
    inputs.pix2tex.packages.x86_64-linux.default
    clip-latex
  ];
}
