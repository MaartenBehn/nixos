{ lib, pkgs, inputs, ... }:
let
  beets-plugin-xtractor = pkgs.callPackage ./beets-plugin-xtractor.nix {
    inherit lib;
    inherit (pkgs) fetchPypi essentia-extractor python3Packages;
    beets = pkgs.python3Packages.beets-minimal;
  };

  beets-plugin-lidarrfields = pkgs.callPackage ./beets-plugin-lidarrfields.nix {
    inherit lib;
    inherit (pkgs) fetchPypi python3Packages;
    beets = pkgs.python3Packages.beets-minimal;
  };

  beets-plugin-check = pkgs.callPackage ./beets-plugin-check.nix {
    inherit lib;
    inherit (pkgs) fetchPypi python3Packages;
    beets = pkgs.python3Packages.beets-minimal;
  };

  beets-plugin-dependencies =
    (with pkgs; [
      chromaprint
      ffmpeg-headless
      keyfinder-cli
      mp3val
      flac
      liboggz # For oggz-validate
    ])
    ++ (with pkgs.python3Packages; [
      requests
      discogs-client
      pyacoustid
      requests-oauthlib
    ]);

  my-beets =
    # I don't yet fully grok the difference between override and
    # overrideAttrs in terms of when to employ each - I understand
    # that overrideAttrs creates a new derivation, but I can't
    # always identify why that is advantageous.
    #
    # In this case, I believe that because the base package doesn't
    # have any propagatedBuildInputs, I need to make a new
    # derivation to add this.
    (pkgs.python3Packages.beets.override {
      pluginOverrides = {
        xtractor = {
          enable = true;
          propagatedBuildInputs = [ beets-plugin-xtractor ];
        };

        lidarrfields = {
          enable = true;
          propagatedBuildInputs = [ beets-plugin-lidarrfields ];
        };

        #check = {
        #  enable = true;
        #  propagatedBuildInputs = [ beets-plugin-check ];
        #};
      };
    }).overrideAttrs
      (
        final: prev: {
          # Append our extra deps to the parent list
          propagatedBuildInputs = (prev.propagatedBuildInputs or [ ]) ++ beets-plugin-dependencies;
        }
      );

  cache-dir = "/home/stroby/.config/beets";
  music-dir = "/media/music";
  playlist-dir = "${cache-dir}/playlists";
  essentia-extractor-SVM-models-dir = "${cache-dir}/essentia-extractor-svm_models-v2.1_beta5";
in
{
  home.packages = (with pkgs; [ flac ]);

  programs.beets = {
    enable = true;
    package = my-beets;
    settings =
      (import ./settings.nix {
        inherit (pkgs) keyfinder-cli;
        inherit cache-dir music-dir playlist-dir essentia-extractor-SVM-models-dir;
        
        # Use newer veriosn not in nixpkgs
        #essentia-extractor = pkgs.essentia-extractor;
        essentia-extractor = pkgs.stdenv.mkDerivation {
          pname = "streaming_extractor_music";
          version = "2.1_beta5";

          src = pkgs.fetchurl {
            url = "https://github.com/p-laranjinha/essentia-nix/raw/f4566b964dfd1c23f880f2bb1a6fe382b7d6e114/streaming_extractor_music";
            hash = "sha256-5HLUF1RXbOMQumTQ1GAfN8HcNn14xORitJP9Npvh3X8=";
          };

          dontUnpack = true;

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
          ];

          buildInputs = [
            pkgs.glibc
          ];

          installPhase = ''
            mkdir -p $out/bin
            install -m755 $src $out/bin/streaming_extractor_music
          '';
        };
       });
      #// (import ../../../../secrets/sun/beets.nix { });
  };

  home.file."${essentia-extractor-SVM-models-dir}" = {
    enable = true;
    recursive = true;
    source = pkgs.fetchzip {
      url = "https://essentia.upf.edu/svm_models/essentia-extractor-svm_models-v2.1_beta5.tar.gz";
      hash = "sha256-xLx0LUwpTlTzKgbfemBDgSKQgtESzk1zooQuBAkN+oY=";
    };
  }; 
}
