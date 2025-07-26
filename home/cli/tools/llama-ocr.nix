{ pkgs, ... }: {

  # https://github.com/Nutlope/llama-ocr?tab=readme-ov-file
  home.packages = [
    pkgs.buildNpmPackage rec {
      pname = "llama-ocr";
      version = "0.0.1";
      src = ./.;
      # Generate a new hash using:
      # nix develop
      # npm i --package-lock-only
      # prefetch-npm-deps package-lock.json
      npmDepsHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
      npmBuildScript = "build";
      installPhase = ''
mkdir -p $out/bin $out/lib
cp -rv build $out/lib
cp -rv package.json $out/lib

cat > $out/bin/${pname} << EOF
#!/bin/sh
        ${pkgs.lib.getExe pkgs.nodejs} $out/lib/build
        EOF

        chmod +x $out/bin/${pname}
      '';
      meta.mainProgram = "${pname}";
    }
  ];
}
