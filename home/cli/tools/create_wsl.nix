{ ... }: {
  home.shellAliases = { 
    wsl-nix-build="cd /home/$USER/nixos/ && nix build .#nixosConfigurations.wsl.config.system.build.tarballBuilder && cd -";
  };
}
