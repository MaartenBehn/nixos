{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  name = "cache-test-pkg-0.1.0";
  
  # A unique dummy source so its output hash doesn't exist anywhere online
  src = builtins.toFile "test-source.txt" "cache-test-unique-payload-${toString builtins.currentTime}";

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    echo '#!/bin/sh' > $out/bin/cache-test
    echo 'echo "Hello from custom binary cache!"' >> $out/bin/cache-test
    chmod +x $out/bin/cache-test
  '';
}
