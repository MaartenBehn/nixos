{ ... }: {
  home.shellAliases = { 
    nix-build-wsl="cd /home/$USER/nixos/ && nix build .#nixosConfigurations.wsl.config.system.build.tarballBuilder && sudo result/bin/nixos-wsl-tarball-builder && cd -";
  };
}
