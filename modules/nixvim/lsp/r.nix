{
  nixvimConfig = { pkgs, ... }: {
    extraPlugins = [(pkgs.vimUtils.buildVimPlugin {
      name = "Nvim-R";
      src = pkgs.fetchFromGitHub {
        owner = "jalvesaq";
        repo = "Nvim-R";
        rev = "295857d133a5c8c8840486abd34d36b5112edfa9";
        hash = "sha256-mVsxegpycc7OQ4CNcH1i09qADLPrJoSRux+Zy1cb0Ds=";
      };
    })];
  };
}
