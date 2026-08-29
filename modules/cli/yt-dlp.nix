{ self, ... }: {
  flake.modules.homeManager.yt-dlp = { pkgs, pkgs-unstable, ... }: {
    home.packages = with pkgs; [
      deno
    ];

    programs.yt-dlp = {
      enable = true;
      package = pkgs-unstable.yt-dlp;
      settings = {
        js-runtimes = "deno";
      };
    };
  };

  flake.modules.homeManager.cli-full = {
    imports = [
      self.modules.homeManager.yt-dlp
    ];
  };
}
