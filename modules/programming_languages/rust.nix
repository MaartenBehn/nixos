{
  flake.modules.homeManager.code = { pkgs, ... }: {
    home.packages = (with pkgs; [
      cargo
      rustc
    ]);
  };
}
