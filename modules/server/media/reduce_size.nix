{
  flake.modules.nixos.server = { pkgs, ... }:

  let
    root = "/mnt/Data/media/videos";

    # -------------------------------------------------------------------
    # Worker: runs inside one derivation on a remote builder.
    # args: input crf|auto cq preset vmaf-target output
    # -------------------------------------------------------------------
    worker = pkgs.writeShellScript "media-worker" ''
      set -Eeuo pipefail

      in=$1 crf=$2 cq=$3 preset=$4 vmaf=$5 out=$6
      KEEP="eng ger deu jpn und"

      export LD_LIBRARY_PATH="/run/opengl-driver/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
      log() { echo "[$(date +%H:%M:%S)] $*" >&2; }

      savings() {
        awk -v a="$1" -v b="$2" 'BEGIN {
          printf "%.0f MiB -> %.0f MiB (saved %.0f MiB, %.1f%%)",
            a / 1048576, b / 1048576, (a - b) / 1048576, (a > 0 ? (a - b) * 100 / a : 0)
        }'
      }

      dur() {
        ffprobe -v error -show_entries format=duration -of default=nw=1:nk=1 "$1"
      }

      # Prints progress, elapsed time and ETA from ffmpeg's -progress stream.
      progress() {
        local k v now last=0 start=$SECONDS
        while IFS== read -r k v; do
          [[ $k == out_time_us && $v =~ ^[0-9]+$ ]] || continue
          now=$((SECONDS - start))
          ((now - last >= 10)) || continue
          last=$now
          awk -v t="$total" -v d="$v" -v e="$now" '
            function hms(s) { return sprintf("%dh%02dm%02ds", s / 3600, (s % 3600) / 60, s % 60) }
            BEGIN {
              p = d / 1e6
              if (p <= 0 || e <= 0 || t <= 0) exit
              printf "progress %.1f%% | elapsed %s | ETA %s | speed %.2fx\n",
                p * 100 / t, hms(e), hms(e * (t - p) / p), p / e
            }' >&2
        done
      }

      info=$(ffprobe -v error \
        -show_entries stream=index,codec_type,codec_name,channels:stream_tags=language \
        -of json "$in")
      count() { jq --arg t "$1" '[.streams[] | select(.codec_type == $t)] | length' <<< "$info"; }

      total=$(dur "$in")

      # Keyframe interval: one closed-GOP IDR frame every 2 seconds. Players and
      # Jellyfin's HLS remux need regular keyframes to seek and to cut segments.
      gop=$(ffprobe -v error -select_streams v:0 -show_entries stream=avg_frame_rate \
              -of csv=p=0 "$in" |
            awk -F/ '{ f = ($2 > 0 ? $1 / $2 : 24); g = int(f * 2 + 0.5); print (g < 12 ? 12 : g) }')
      in_size=$(stat -c %s "$in")
      log "input: $((in_size / 1048576)) MiB, ''${total%.*}s, host $(uname -n), keyframe every $gop frames"

      # Prints "index codec channels" for kept streams of a type.
      # $2 = fall back to all streams if no language matches.
      pick() {
        jq -r --arg t "$1" --arg k "$KEEP" --argjson fb "$2" '
          [.streams[] | select(.codec_type == $t)] as $all
          | [$all[] | select((.tags.language // "und") as $l
                             | ($k | split(" ") | index($l)) != null)] as $keep
          | (if ($keep | length) > 0 or ($fb | not) then $keep else $all end)[]
          | "\(.index) \(.codec_name) \(.channels // 2)"' <<< "$info"
      }

      args=(-map 0:v:0)

      # Audio: keep wanted languages, convert only the big lossless/DTS tracks.
      n=0
      while read -r idx codec ch; do
        args+=(-map "0:$idx")
        case $codec in
          dts|truehd|flac|pcm_*)
            args+=("-c:a:$n" aac
            "-b:a:$n" 192k
            "-ac:a:$n" 2)
            log "audio #$idx: $codec -> AAC stereo 192k"
            ;;
          *)
            log "audio #$idx: $codec -> copy"
            ;;
        esac
        n=$((n + 1))
      done < <(pick audio true)
      log "audio: kept $n of $(count audio) tracks"

      # Subtitles: MP4 supports mov_text for text subs, but cannot mux bitmap
      # subs (PGS/VobSub) or MKV font attachments.
      n=0
      while read -r idx codec _; do
        case $codec in
          subrip|srt|ass|ssa|mov_text|webvtt|text)
            args+=(-map "0:$idx" "-c:s:$n" mov_text)
            log "subtitle #$idx: $codec -> mov_text"
            n=$((n + 1))
            ;;
          *)
            log "subtitle #$idx: $codec -> skipped (unsupported in MP4)"
            ;;
        esac
      done < <(pick subtitle false)
      log "subtitles: kept $n of $(count subtitle) tracks"
      log "attachments: skipped (not supported in MP4)"

      encode() {
        local o_dur o_size
        rm -f "$out"
        log "ffmpeg: $*"

        ffmpeg -nostdin -hide_banner -loglevel error -nostats -progress pipe:1 \
        -y -i "$in" \
        -c copy "''${args[@]}" "$@" \
        -force_key_frames "expr:gte(t,n_forced*2)" \
        -movflags +faststart \
        -f mp4 "$out" | progress \
        || { log "ffmpeg failed"; return 1; }

        [[ -s $out ]] || { log "output is empty"; return 1; }

        o_dur=$(dur "$out")
        awk -v a="$total" -v b="$o_dur" 'BEGIN { d = a - b; exit !(d < 2 && d > -2) }' \
          || { log "duration mismatch: $total vs $o_dur"; return 1; }

        o_size=$(stat -c %s "$out")
        (( o_size < in_size )) \
          || { log "output not smaller: $(savings "$in_size" "$o_size")"; return 1; }

        log "result: $(savings "$in_size" "$o_size")"
      }

      # ---- video encoder settings -------------------------------------
      # Detect whether the source needs 10-bit encoding.
      source_video=$(ffprobe -v error -select_streams v:0 \
        -show_entries stream=pix_fmt,color_transfer \
        -of json "$in")

      source_pix=$(jq -r '.streams[0].pix_fmt // ""' <<< "$source_video")
      source_transfer=$(jq -r '.streams[0].color_transfer // ""' <<< "$source_video")

      if [[ $source_pix == *10* || $source_pix == *12* ||
        $source_transfer == smpte2084 ||
        $source_transfer == arib-std-b67 ]]; then
        PIXFMT=10
        log "video: preserving 10-bit/HDR encoding"
      else
        PIXFMT=8
        log "video: using 8-bit SDR encoding"
      fi

      # set_v ENCODER QUALITY PRESET -> fills V=(...)
      set_v() {
        case $1 in
          nvenc)
            if (( PIXFMT == 10 )); then
              V=(-c:v hevc_nvenc
              -preset p6
              -tune hq
              -rc vbr
              -cq "$2"
              -b:v 0
              -profile:v main10
              -pix_fmt p010le
              -spatial-aq 1
              -rc-lookahead 32
              -g "$gop"
              -forced-idr 1
              -no-scenecut 1
              -strict_gop 1)
            else
              V=(-c:v hevc_nvenc
              -preset p6
              -tune hq
              -rc vbr
              -cq "$2"
              -b:v 0
              -profile:v main
              -pix_fmt nv12
              -spatial-aq 1
              -rc-lookahead 32
              -g "$gop"
              -forced-idr 1
              -no-scenecut 1
              -strict_gop 1)
            fi
            ;;

          x265)
            if (( PIXFMT == 10 )); then
              V=(-c:v libx265
              -crf "$2"
              -preset "$3"
              -pix_fmt yuv420p10le
              -g "$gop"
              -x265-params "log-level=error:keyint=$gop:min-keyint=$gop:scenecut=0:open-gop=0:repeat-headers=1")
            else
              V=(-c:v libx265
              -crf "$2"
              -preset "$3"
              -pix_fmt yuv420p
              -g "$gop"
              -x265-params "log-level=error:keyint=$gop:min-keyint=$gop:scenecut=0:open-gop=0:repeat-headers=1")
            fi
            ;;
        esac
      }

      # ---- automatic quality search (VMAF on short samples) -----------
      work=$(mktemp -d)
      trap 'rm -rf "$work"' EXIT

      make_samples() {
        local pos i=0
        log "search: cutting sample clips"
        for pos in $(awk -v t="$total" -v l=15 'BEGIN {
            if (t < 90) { print 0; exit }
            for (i = 1; i <= 3; i++) printf "%d\n", t * i / 4 - l / 2
          }'); do
          ffmpeg -nostdin -hide_banner -loglevel error -y -ss "$pos" -i "$in" -t 15 \
            -map 0:v:0 -c copy -an -sn -dn "$work/ref_$i.mkv" || return 1
          i=$((i + 1))
        done
      }

      # Mean VMAF over all sample clips at quality $1 (fast preset for speed).
      sample_score() {
        local ref s sum=0 n=0
        set_v "$ENC" "$1" fast
        for ref in "$work"/ref_*.mkv; do
          ffmpeg -nostdin -hide_banner -loglevel error -y -i "$ref" "''${V[@]}" \
            -an -sn "$work/dist.mkv" || return 1
          ffmpeg -nostdin -hide_banner -loglevel error -y -i "$work/dist.mkv" -i "$ref" \
            -lavfi "[0:v]format=yuv420p10le,setpts=PTS-STARTPTS[d];[1:v]format=yuv420p10le,setpts=PTS-STARTPTS[r];[d][r]libvmaf=n_threads=$(nproc):log_fmt=json:log_path=$work/vmaf.json" \
            -f null - || return 1
          s=$(jq '.pooled_metrics.vmaf.mean' "$work/vmaf.json") || return 1
          sum=$(awk -v a="$sum" -v b="$s" 'BEGIN { print a + b }')
          n=$((n + 1))
        done
        awk -v a="$sum" -v n="$n" 'BEGIN { printf "%.2f", a / n }'
      }

      # Binary search for the highest quality value (smallest file) with VMAF >= target.
      find_quality() {
        local lo hi mid score found=0
        if [[ $ENC == nvenc ]]; then lo=20 hi=34; else lo=18 hi=32; fi
        Q=$lo
        make_samples || { log "search: cutting samples failed"; return 1; }

        while ((lo <= hi)); do
          mid=$(((lo + hi) / 2))
          score=$(sample_score "$mid") || { log "search: sample encode failed"; return 1; }
          log "search: $ENC quality $mid -> VMAF $score (target $vmaf)"
          if awk -v s="$score" -v t="$vmaf" 'BEGIN { exit !(s >= t) }'; then
            Q=$mid found=1
            lo=$((mid + 1))
          else
            hi=$((mid - 1))
          fi
        done

        ((found)) || log "search: target not reached, using best quality $Q"
        log "search: chose quality $Q"
      }

      run_encoder() {
        ENC=$1
        if [[ $crf == auto ]]; then
          find_quality || return 1
        elif [[ $ENC == nvenc ]]; then
          Q=$cq
        else
          Q=$crf
        fi
        set_v "$ENC" "$Q" "$preset"
        log "encoding with $ENC (quality $Q, preset $preset)"
        encode "''${V[@]}"
      }

      if [[ -e /dev/nvidiactl ]]; then
        log "GPU found, using NVENC"
        run_encoder nvenc && exit 0
        log "NVENC failed, falling back to x265"
      fi

      run_encoder x265 || { rm -f "$out"; log "encode failed"; exit 1; }
    '';

    # -------------------------------------------------------------------
    # Nix expression: one derivation per file, linked together.
    # -------------------------------------------------------------------
    builder = pkgs.writeText "media-builder.nix" ''
      let
        pkgs = import ${pkgs.path} { };
        worker = ${worker};
        jobs = builtins.fromJSON (builtins.readFile (builtins.getEnv "MEDIA_MANIFEST"));
      in
      (pkgs.linkFarm "media-batch" (map (e: {
        name = e.rel;
        path = pkgs.runCommand
          "media-''${builtins.substring 0 12 (builtins.hashString "sha256" e.rel)}"
          {
            src = builtins.path { path = e.src; name = "media-input"; };
            nativeBuildInputs = with pkgs; [ ffmpeg-full jq gawk coreutils ];
            requiredSystemFeatures = [
              "big-parallel"
              # "nvidia-gpu"
            ];
            __noChroot = true;
          }
          "''${worker} $src ''${toString e.crf} ''${toString e.cq} ''${e.preset} ''${toString e.vmaf} $out";
      }) jobs)).overrideAttrs (_: {
        preferLocalBuild = true;
        allowSubstitutes = false;
      })
    '';

    # -------------------------------------------------------------------
    # CLI
    # -------------------------------------------------------------------
    mediaBuild = pkgs.writeShellApplication {
      name = "media-build";
      excludeShellChecks = [ "SC2016" ]; # jq/awk programs live in single quotes
      runtimeInputs = with pkgs; [
        nix nix-output-monitor ffmpeg jq coreutils findutils gawk
      ];
      text = ''
        ROOT="${root}"
        STATE="''${XDG_STATE_HOME:-$HOME/.local/state}/media-build/jobs"
        MIN_BPS=4000000   # HEVC/AV1 files below this bitrate are skipped
        mkdir -p "$STATE"

        die() { echo "error: $*" >&2; exit 1; }

        savings() {
          awk -v a="$1" -v b="$2" 'BEGIN {
            printf "%.0f MiB -> %.0f MiB (saved %.0f MiB, %.1f%%)",
              a / 1048576, b / 1048576, (a - b) / 1048576, (a > 0 ? (a - b) * 100 / a : 0)
          }'
        }

        # Per-file and total savings of a finished (not yet deployed) job.
        report() {
          local link rel a b ta=0 tb=0
          while IFS= read -r -d "" link; do
            rel=''${link#"$1/result"/}
            a=$(stat -c %s "$ROOT/$rel")
            b=$(stat -L -c %s "$link")
            echo "  $rel: $(savings "$a" "$b")"
            ta=$((ta + a))
            tb=$((tb + b))
          done < <(find -H "$1/result" -type l -print0)
          echo "Total: $(savings "$ta" "$tb")"
        }

        # NUL-separated absolute paths of video files below the given paths.
        discover() {
          local p abs
          for p in "$@"; do
            abs=$(realpath -e -- "$p") || die "Missing: $p"
            [[ $abs == "$ROOT" || $abs == "$ROOT"/* ]] || die "Outside media root: $p"
            find "$abs" -type d \( -name '.*' -o -name backups \) -prune -o \
              -type f \( -iname '*.mkv' -o -iname '*.mp4' -o -iname '*.m4v' -o -iname '*.avi' \) \
              -print0
          done
        }

        # Prints "codec bitrate" of the first video stream.
        probe() {
          ffprobe -v error -select_streams v:0 \
            -show_entries stream=codec_name:format=bit_rate -of json "$1" |
            jq -r '[.streams[0].codec_name, (.format.bit_rate // 0)] | join(" ")'
        }

        scan() {
          local f c br n=0
          while IFS= read -r -d "" f; do
            read -r c br < <(probe "$f")
            awk -v s="$(stat -c %s "$f")" -v c="$c" -v b="$br" -v f="''${f#"$ROOT"/}" 'BEGIN {
              printf "%8.1f MiB | %-6s | %5.1f Mbps | %s\n", s / 1048576, c, b / 1e6, f
            }'
            n=$((n + 1))
          done < <(discover "$@")
          echo "Found $n files."
        }

        # build_batch fixed|auto [OPTIONS] PATH...
        build_batch() {
          local mode=$1 crf=23 cq=26 vmaf=96 preset=medium force=0 a
          shift
          local -a paths=()
          for a in "$@"; do
            case $a in
              --crf=*) crf=''${a#--crf=} ;;
              --cq=*) cq=''${a#--cq=} ;;
              --vmaf=*) vmaf=''${a#--vmaf=} ;;
              --preset=*) preset=''${a#--preset=} ;;
              --force) force=1 ;;
              -*) die "Unknown option: $a" ;;
              *) paths+=("$a") ;;
            esac
          done
          [[ $crf =~ ^[0-9]+$ ]] || die "Invalid CRF"
          ((crf <= 51)) || die "CRF must be at most 51"
          [[ $cq =~ ^[0-9]+$ ]] || die "Invalid CQ"
          ((cq <= 51)) || die "CQ must be at most 51"
          [[ $vmaf =~ ^[0-9]+$ ]] || die "Invalid VMAF target"
          ((vmaf >= 50 && vmaf <= 99)) || die "VMAF target must be 50-99"
          [[ $preset =~ ^[a-z0-9_-]+$ ]] || die "Invalid preset"
          ((''${#paths[@]})) || die "Specify paths"

          local job f rel c br size n=0 queued=0 desc="crf $crf (x265) / cq $cq (NVENC)"
          if [[ $mode == auto ]]; then
            crf=auto
            desc="automatic quality search, VMAF target $vmaf"
          fi
          job="$STATE/$(date +%Y%m%d-%H%M%S)"
          mkdir -p "$job"

          while IFS= read -r -d "" f; do
            rel=$(realpath --relative-to="$ROOT" "$f")
            read -r c br < <(probe "$f")
            if [[ $c == hevc || $c == av1 ]] && ((br < MIN_BPS)) && ((!force)); then
              echo "SKIP:   $rel ($c, $((br / 1000)) kbps)"
              continue
            fi
            jq -nc --arg rel "$rel" --arg src "$f" --arg crf "$crf" --argjson cq "$cq" --argjson vmaf "$vmaf" \
              --arg preset "$preset" '$ARGS.named' >> "$job/entries"
            size=$(stat -c %s "$f")
            echo "QUEUED: $rel ($c, $((size / 1048576)) MiB, $((br / 1000)) kbps)"
            queued=$((queued + size))
            n=$((n + 1))
          done < <(discover "''${paths[@]}")

          ((n > 0)) || { rmdir "$job" 2>/dev/null || true; echo "Nothing to build."; return 0; }
          jq -s . "$job/entries" > "$job/manifest.json"
          echo "Building $n files, $((queued / 1048576)) MiB total ($desc, preset $preset)."

          # One local job slot is needed for the symlink farm. Encode tasks need
          # the "nvidia-gpu" feature, which this machine does not advertise, so
          # they can only run on the workers listed in /run/nix/active_builders.
          MEDIA_MANIFEST="$job/manifest.json" nom build --impure \
            --builders "@/run/nix/active_builders" --max-jobs 1 \
            --file "${builder}" --out-link "$job/result" \
            || die "Build failed (manifest kept at $job/manifest.json)"

          touch "$job/completed"
          echo "Build finished. Expected savings:"
          report "$job"
          echo "Run: media-build deploy"
        }

        deploy() {
          local job link rel dest final new tmp bak a b n=0 ta=0 tb=0
          for job in "$STATE"/*; do
            [[ -f $job/completed && ! -f $job/deployed ]] || continue

            while IFS= read -r -d "" link; do
              rel=''${link#"$job/result"/}
              dest="$ROOT/$rel"
              final="''${dest%.*}.mp4"
              new=$(readlink -f "$link")

              [[ -f $dest && -f $new ]] || die "Missing file for $rel"
              a=$(stat -c %s "$dest")
              b=$(stat -c %s "$new")
              if ((b >= a)); then
                echo "SKIP (not smaller): $rel"
                continue
              fi

              bak="$ROOT/backups/$rel"
              mkdir -p "$(dirname "$bak")"
              [[ -e $bak ]] || cp -p "$dest" "$bak"

              tmp=$(mktemp "$(dirname "$dest")/.media-build.XXXXXX")
              cp "$new" "$tmp"
              # mktemp creates 0600 files; copy mode and group from the original so
              # Jellyfin (and other users of the library) can still read the result.
              chmod --reference="$dest" "$tmp"
              chown --reference="$dest" "$tmp" 2>/dev/null || chgrp --reference="$dest" "$tmp" 2>/dev/null || true
              ffprobe -v error "$tmp" || { rm -f "$tmp"; die "Invalid output: $rel"; }
              mv -f "$tmp" "$final"
              [[ $final == "$dest" ]] || rm -f "$dest"

              echo "DEPLOYED: $rel: $(savings "$a" "$b")"
              ta=$((ta + a))
              tb=$((tb + b))
              n=$((n + 1))
            done < <(find -H "$job/result" -type l -print0)

            touch "$job/deployed"
          done
          echo "Deployed $n files. Total: $(savings "$ta" "$tb")"
        }

        status() {
          local j state
          for j in "$STATE"/*; do
            [[ -d $j ]] || continue
            state=INCOMPLETE
            [[ ! -f $j/completed ]] || state=READY
            [[ ! -f $j/deployed ]] || state=DEPLOYED
            echo "$(basename "$j") | $state | $(jq length "$j/manifest.json" 2>/dev/null || echo 0) files"
          done
        }

        case "''${1:-help}" in
          scan)   shift; scan "$@" ;;
          encode) shift; build_batch fixed "$@" ;;
          auto)   shift; build_batch auto "$@" ;;
          deploy) deploy ;;
          status) status ;;
          *)
            echo "Usage: media-build scan PATH... | encode [--crf=26] [--cq=30] [--preset=medium] [--force] PATH... | auto [--vmaf=94] [--preset=medium] [--force] PATH... | deploy | status"
            ;;
        esac
      '';
    };
  in {
    environment.systemPackages = [ mediaBuild ];
  };
}
