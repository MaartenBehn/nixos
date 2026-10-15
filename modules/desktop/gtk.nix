{
  flake.modules.homeManager.hyprland = { pkgs, config, ... }: let
    emojiMappings = {
      "23F1" = "f520"; # ⏱ Stopwatch -> nf-oct-stopwatch
      "23F5" = "F04B"; # ⏵ Play      -> nf-fa-play
      "23F8" = "F04C"; # ⏸ Pause     -> nf-fa-pause
    };

    mappingsPythonDict = "{" + pkgs.lib.concatStringsSep ", " (
      pkgs.lib.mapAttrsToList (k: v: "0x${k}: 0x${v}") emojiMappings
    ) + "}";

    patchScript = pkgs.writeText "patch-emoji.py" ''
    import sys
    from fontTools.ttLib import TTFont

    def main():
        if len(sys.argv) < 3:
            print("Usage: patch-emoji.py <input.ttf> <output.ttf>")
            sys.exit(1)

        input_path = sys.argv[1]
        output_path = sys.argv[2]

        print(f"Loading font: {input_path}")
        font = TTFont(input_path)

        # Mappings injected dynamically from Nix
        mappings = ${mappingsPythonDict}

        patched_count = 0
        for table in font["cmap"].tables:
            if table.isUnicode():
                for target_cp, source_cp in mappings.items():
                    if source_cp in table.cmap:
                        glyph_name = table.cmap[source_cp]
                        table.cmap[target_cp] = glyph_name
                        print(f"  -> Mapped Unicode U+{target_cp:04X} to glyph U+{source_cp:04X} ({glyph_name})")
                        patched_count += 1

        if patched_count == 0:
            print("Warning: No matching source glyphs found in this table.")

        font.save(output_path)
        print(f"Saved patched font to: {output_path}")

    if __name__ == "__main__":
        main()
  '';
  patchedNerdEmojiFont = pkgs.stdenv.mkDerivation {
    pname = "jetbrains-mono-nerd-emoji-patched";
    version = "1.0";
    src = pkgs.nerd-fonts.jetbrains-mono;

    nativeBuildInputs = [ 
      pkgs.python3 
      pkgs.python3Packages.fonttools 
    ];

        buildCommand = #bash
          ''
          target_dir="$out/share/fonts/truetype/NerdFonts/JetBrainsMono"
          mkdir -p "$target_dir"

          for font_file in $(find "$src" -name "*.ttf"); do
            filename=$(basename "$font_file")
            output_file="$target_dir/$filename"

            echo "----------------------------------------"
            echo "Processing: $filename"

            python3 ${patchScript} "$font_file" "$output_file"
          done
          echo "----------------------------------------"
        '';
      };
    in {   
      home.packages = with pkgs; [
        patchedNerdEmojiFont
        openmoji-black
        noto-fonts-monochrome-emoji
        kitty.terminfo
      ];

      fonts.fontconfig = {
        enable = true;
        defaultFonts = {
          monospace = [ "JetBrainsMono Nerd Font" ];
          emoji     = [ "JetBrainsMono Nerd Font" "OpenMoji Black" "Noto Emoji" ];
        };
      };

      gtk = {
        enable = true;

        font = {
          name = "JetBrainsMono Nerd Font";         
          size = 12;
        };

        theme = {
          name = "Colloid-Green-Dark-Gruvbox";
          package = pkgs.colloid-gtk-theme.override {
            colorVariants = [ "dark" ];
            themeVariants = [ "green" ];
            tweaks = [
              "gruvbox"
              "rimless"
              "float"
            ];
          };
        };

        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.papirus-icon-theme.override { color = "black"; };
        };

        cursorTheme = {
          name = "Bibata-Modern-Ice";
          package = pkgs.bibata-cursors;
          size = 24;
        };
      };

      gtk.gtk4.theme = config.gtk.theme;

      home.pointerCursor = {
        enable = true;
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
        size = 24;
      };
    };
}
