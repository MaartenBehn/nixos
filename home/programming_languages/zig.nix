{ inputs, pkgs, system, ... }: {
  home.packages = (with pkgs; [
    inputs.zig.packages.${system}.master
    zls
 ]);
}
