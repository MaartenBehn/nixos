{
  flake.modules.homeManager.code = { pkgs, ... }: {
    home.packages = (with pkgs; [
      gcc
      gdb
      gnumake
      valgrind                          # c memory analyzer
    ]);
  };
}
