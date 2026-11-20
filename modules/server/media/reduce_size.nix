{
  flake.modules.nixos.server = { pkgs, ... }:

  let
    root = "/mnt/Data/media/videos";

    # -------------------------------------------------------------------------
    # One worker invocation = one media file.
    # -------------------------------------------------------------------------

    mediaWorker = pkgs.writeShellScript "media-worker" ''
      set -euo pipefail

      input="$1"
      mode="$2"
      crf="$3"
      preset="$4"
      output="$5"

      KEEP_LANGS=(eng ger deu jpn und)

      die() {
        echo "error: $*" >&2
        exit 1
      }

      duration() {
        ffprobe -v error \
          -show_entries format=duration \
          -of default=nw=1:nk=1 "$1"
      }

      filesize() {
        stat -c %s "$1"
      }

      durations_close() {
        awk -v a="$1" -v b="$2" \
          'BEGIN {
            exit !(a ~ /^[0-9.]+$/ &&
                   b ~ /^[0-9.]+$/ &&
                   a-b < 2 && b-a < 2)
          }'
      }

      is_kept_lang() {
        local l
        for l in "''${KEEP_LANGS[@]}"; do
          [[ "$1" == "$l" ]] && return 0
        done
        return 1
      }

      AUDIO_ALL=()
      AUDIO_KEEP=()
      AUDIO_MAPS=()

      while IFS=, read -r idx lang; do
        [[ -n "''${idx:-}" ]] || continue

        AUDIO_ALL+=("$idx")

        if is_kept_lang "''${lang:-und}"; then
          AUDIO_KEEP+=("$idx")
        fi
      done < <(
        ffprobe -v error \
          -select_streams a \
          -show_entries stream=index:stream_tags=language \
          -of csv=p=0 "$input"
      )

      if ((''${#AUDIO_KEEP[@]} == 0)); then
        AUDIO_KEEP=("''${AUDIO_ALL[@]}")
      fi

      for idx in "''${AUDIO_KEEP[@]}"; do
        AUDIO_MAPS+=(-map "0:$idx")
      done

      case "$mode" in
        remux)
          if ((''${#AUDIO_KEEP[@]} == ''${#AUDIO_ALL[@]})); then
            die "No audio tracks to remove"
          fi

          ffmpeg -nostdin -hide_banner -loglevel error -y \
            -i "$input" \
            -map "0:v?" \
            "''${AUDIO_MAPS[@]}" \
            -map "0:s?" \
            -map "0:t?" \
            -c copy \
            -f matroska "$output"
          ;;

        encode)
          ffmpeg -nostdin -hide_banner -loglevel error -y \
            -i "$input" \
            -map 0:v:0 \
            "''${AUDIO_MAPS[@]}" \
            -map "0:s?" \
            -map "0:t?" \
            -c copy \
            -c:v libx265 \
            -crf "$crf" \
            -preset "$preset" \
            -pix_fmt yuv420p10le \
            -x265-params log-level=error \
            -f matroska "$output"
          ;;

        *)
          die "Unknown mode: $mode"
          ;;
      esac

      [[ -s "$output" ]] || die "Empty output"

      durations_close "$(duration "$input")" "$(duration "$output")" \
        || die "Duration mismatch"

      (( $(filesize "$output") < $(filesize "$input") )) \
        || die "Output is not smaller"

      echo "Successfully processed: $input"
    '';

    # -------------------------------------------------------------------------
    # Nix expression template.
    #
    # This is a plain Nix string. It contains no nested shell indented strings.
    # The worker is invoked directly through runCommand's shell argument.
    # -------------------------------------------------------------------------

    mediaBuilder = pkgs.writeText "media-builder.nix" ''
      let
        pkgs = import ${pkgs.path} {};

        entries = builtins.fromJSON (
          builtins.readFile (builtins.getEnv "MEDIA_MANIFEST")
        );

        worker = ${mediaWorker};

        mkJob = entry:
          let
            src = builtins.path {
              path = entry.src;
              name = "media-input";
            };

            hash = builtins.substring 0 12
              (builtins.hashString "sha256" entry.rel);

            mode = pkgs.lib.escapeShellArg entry.mode;
            crf = toString entry.crf;
            preset = pkgs.lib.escapeShellArg entry.preset;

          in pkgs.runCommand "media-''${hash}" {
            inherit src;

            nativeBuildInputs = [
              pkgs.ffmpeg
              pkgs.coreutils
              pkgs.gawk
            ];

            preferLocalBuild = false;
            allowSubstitutes = true;

          } (
            "set -euo pipefail\n" +
            "''${worker} \"$src\" " +
            mode + " " +
            crf + " " +
            preset + " \"$out\"\n"
          );

        jobs = map (entry: {
          name = entry.rel;
          path = mkJob entry;
        }) entries;

      in
        pkgs.linkFarm "media-batch" jobs
    '';

    # -------------------------------------------------------------------------
    # CLI.
    # -------------------------------------------------------------------------

    mediaBuild = pkgs.writeShellApplication {
      name = "media-build";

      runtimeInputs = with pkgs; [
        nix
        ffmpeg
        coreutils
        findutils
        gawk
        jq
      ];

      text = ''
        set -euo pipefail

        ROOT="${root}"
        STATE="''${XDG_STATE_HOME:-$HOME/.local/state}/media-build"
        JOBS="$STATE/jobs"

        mkdir -p "$JOBS"

        die() {
          echo "error: $*" >&2
          exit 1
        }

        usage() {
          cat <<'EOF'
        Usage:
          media-build scan PATH...
          media-build encode [OPTIONS] PATH...
          media-build remux PATH...
          media-build deploy
          media-build status

        Options:
          --crf=N
          --preset=NAME
          --force

        Examples:
          media-build scan Movies/
          media-build encode Movies/
          media-build encode Shows/Anime/
          media-build encode Movies/Movie.mkv
          media-build encode --crf=24 Movies/
          media-build remux Shows/
          media-build deploy
          media-build status
        EOF
        }

        FILES=()
        declare -A SEEN=()

        add_file() {
          local f="$1"
          local rel

          rel=$(realpath --relative-to="$ROOT" "$f")

          [[ "$rel" != backups/* ]] || return 0

          if [[ -z "''${SEEN[$rel]+x}" ]]; then
            SEEN[$rel]=1
            FILES+=("$rel")
          fi
        }

        discover() {
          local arg abs f

          for arg in "$@"; do
            if [[ "$arg" == /* ]]; then
              abs=$(realpath -e -- "$arg") || die "Missing: $arg"
            else
              abs=$(realpath -e -- "$PWD/$arg") || die "Missing: $arg"
            fi

            # Reject paths outside the media root.
            case "$abs" in
              "$ROOT"|"$ROOT"/*) ;;
              *) die "Path outside media root: $arg" ;;
            esac

            if [[ -d "$abs" ]]; then
              while IFS= read -r -d "" f; do
                add_file "$f"
              done < <(
                find "$abs" \
                  -type d \( -name '.*' -o -name backups \) -prune -o \
                  -type f \
                  \( -iname '*.mkv' -o \
                     -iname '*.mp4' -o \
                     -iname '*.m4v' -o \
                     -iname '*.avi' \) \
                  -print0
              )
            elif [[ -f "$abs" ]]; then
              add_file "$abs"
            else
              die "Invalid path: $arg"
            fi
          done
        }

        codec() {
          ffprobe -v error \
            -select_streams v:0 \
            -show_entries stream=codec_name \
            -of default=nw=1:nk=1 "$1" 2>/dev/null || true
        }

        scan() {
          (($# > 0)) || die "Specify paths"

          discover "$@"

          for rel in "''${FILES[@]}"; do
            f="$ROOT/$rel"
            c=$(codec "$f")
            size=$(stat -c %s "$f")

            printf '%8s MiB | %-10s | %s\n' \
              "$(LC_ALL=C awk -v b="$size" 'BEGIN {printf "%.1f", b/1048576}')" \
              "$c" "$rel"          
          done

          echo "Found ''${#FILES[@]} files."
        }

        build_batch() {
          local mode="$1"
          shift

          local crf=22
          local preset=slow
          local force=0
          local -a paths=()

          while (($#)); do
            case "$1" in
              --crf=*) crf="''${1#--crf=}" ;;
              --preset=*) preset="''${1#--preset=}" ;;
              --force) force=1 ;;
              -*) die "Unknown option: $1" ;;
              *) paths+=("$1") ;;
            esac
            shift
          done

          [[ "$crf" =~ ^[0-9]+$ ]] || die "Invalid CRF"
          ((crf <= 51)) || die "CRF must be at most 51"
          [[ "$preset" =~ ^[a-zA-Z0-9_-]+$ ]] || die "Invalid preset"

          ((''${#paths[@]} > 0)) || die "Specify paths"

          discover "''${paths[@]}"
          ((''${#FILES[@]} > 0)) || die "No files found"

          local id job_dir manifest entries rel c src
          id="$(date +%Y%m%d-%H%M%S)-$$"
          job_dir="$JOBS/$id"

          mkdir -p "$job_dir"
          manifest="$job_dir/manifest.json"

          entries=$(mktemp)
          trap 'rm -f "$entries"' RETURN

          local count=0

          for rel in "''${FILES[@]}"; do
            src="$ROOT/$rel"

            if [[ "$mode" == encode ]]; then
              c=$(codec "$src")

              if [[ "$c" == hevc || "$c" == av1 ]] && (( ! force )); then
                echo "SKIP: $rel ($c)"
                continue
              fi
            fi

            jq -n \
              --arg rel "$rel" \
              --arg src "$src" \
              --arg mode "$mode" \
              --arg preset "$preset" \
              --argjson crf "$crf" \
              '{
                rel: $rel,
                src: $src,
                mode: $mode,
                crf: $crf,
                preset: $preset
              }' >> "$entries"

            count=$((count + 1))
            echo "QUEUED: $rel"
          done

          ((count > 0)) || {
            echo "Nothing to build."
            return 0
          }

          jq -s '.' "$entries" > "$manifest"
          rm -f "$entries"
          trap - RETURN

          echo "Building $count independent derivations."

          if MEDIA_MANIFEST="$manifest" \
            nix build \
              --impure \
              --file "${mediaBuilder}" \
              --out-link "$job_dir/result" \
              --print-out-paths; then

            touch "$job_dir/completed"
            echo "Build completed: $job_dir"
          else
            die "Build failed. Job manifest retained at $manifest"
          fi
        }

        deploy() {
          local job_dir result link rel dest target backup tmp
          local count=0

          for job_dir in "$JOBS"/*; do
            [[ -d "$job_dir" ]] || continue
            [[ -f "$job_dir/completed" ]] || continue
            [[ ! -f "$job_dir/deployed" ]] || continue
            [[ -e "$job_dir/result" ]] || continue

            result="$job_dir/result"

            while IFS= read -r -d "" link; do
              rel="''${link#"$result"/}"
              dest="$ROOT/$rel"
              target=$(readlink -f "$link")

              [[ -f "$dest" ]] || die "Missing original: $dest"
              [[ -f "$target" ]] || die "Missing result: $target"

              # Verify output is smaller before deployment.
              (( $(stat -c %s "$target") < $(stat -c %s "$dest") )) \
                || die "Output not smaller: $rel"

              backup="$ROOT/backups/$rel"
              mkdir -p "$(dirname "$backup")"

              if [[ ! -e "$backup" ]]; then
                cp -p "$dest" "$backup.partial"
                mv "$backup.partial" "$backup"
              fi

              tmp=$(mktemp "$(dirname "$dest")/.media-build.XXXXXX")

              if ! cp "$target" "$tmp"; then
                rm -f "$tmp"
                die "Copy failed: $rel"
              fi

              if ! ffprobe -v error "$tmp" >/dev/null 2>&1; then
                rm -f "$tmp"
                die "Invalid output: $rel"
              fi

              mv -f "$tmp" "$dest"

              echo "DEPLOYED: $rel"
              count=$((count + 1))

            done < <(find -H "$result" -type l -print0)

            touch "$job_dir/deployed"
          done

          echo "Deployed $count files."
        }

        status() {
          local d count state

          for d in "$JOBS"/*; do
            [[ -d "$d" ]] || continue

            count=0
            [[ ! -f "$d/manifest.json" ]] || \
              count=$(jq length "$d/manifest.json")

            if [[ -f "$d/deployed" ]]; then
              state=DEPLOYED
            elif [[ -f "$d/completed" ]]; then
              state=READY
            else
              state=INCOMPLETE
            fi

            printf '%s | %s | %s files\n' \
              "$(basename "$d")" "$state" "$count"
          done
        }

        (($# > 0)) || {
          usage
          exit 0
        }

        command="$1"
        shift

        case "$command" in
          scan) scan "$@" ;;
          encode) build_batch encode "$@" ;;
          remux) build_batch remux "$@" ;;
          deploy) deploy ;;
          status) status ;;
          help|-h|--help) usage ;;
          *) die "Unknown command: $command" ;;
        esac
      '';
    };

  in {
    environment.systemPackages = [
      mediaBuild
    ];
  };
}

