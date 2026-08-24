{
  nixvimConfig = { pkgs, ... }: {
    extraPlugins = [(pkgs.vimUtils.buildVimPlugin {
      name = "vim-log-highlighting";
      src = pkgs.fetchFromGitHub {
        owner = "MTDL9";
        repo = "vim-log-highlighting";
        rev = "1037e26f3120e6a6a2c0c33b14a84336dee2a78f";
        hash = "sha256-DqYSCtndUNIZsd9zpTFBhESXw3graNrjGC3WhcZ9uTA=";
      };
    })];
  };
}
