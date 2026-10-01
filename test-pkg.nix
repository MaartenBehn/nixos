{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  name = "cache-test-pkg-0.1.0";
  
  # Static payload ensures the Nix store path hash remains identical across builds
  src = builtins.toFile "test-source.txt" "cache-test-static-payload-v1";

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    echo '#!/bin/sh' > $out/bin/cache-test
    echo 'echo "Hello from custom binary cache!"' >> $out/bin/cache-test
    chmod +x $out/bin/cache-test
  '';
}
