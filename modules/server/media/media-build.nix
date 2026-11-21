{
  flake.modules.nixos.server = { pkgs, ... }:

  let
    root = "/mnt/Data/media/videos";
    buildersFile = "/run/nix/active_builders";

    # Runs on the remote builder. stdin = source video, stdout = resulting MP4.
    # EVERYTHING else (status, progress, errors) goes to stderr, which the ssh
    # tunnel carries back to the local `media-build` process line by line.
    remoteWorkerScript = ''
      set -Eeuo pipefail

      export PATH="/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:$PATH"
      export LD_LIBRARY_PATH="/run/opengl-driver/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

      t_start=$SECONDS
      host=$(uname -n)
      log() { echo "[$host +$((SECONDS - t_start))s] $*" >&2; }

      in_shell=0
      if [[ ''${1:-} == "--in-shell" ]]; then
        in_shell=1
        shift
      fi

      script_path=''${1:-}
      shift || true

      crf=''${1:-23}
      cq=''${2:-26}
      preset=''${3:-medium}
      allow_nvenc=''${4:-1}
      gop=''${5:-48}
      pixfmt=''${6:-8}
      keep_langs=''${7:-"eng ger deu jpn und"}
      ext=''${8:-mkv}

      work=$(mktemp -d /tmp/media-stream.XXXXXX)
      mon_pid=""

      stop_monitor() {
        if [[ -n $mon_pid ]]; then
          kill "$mon_pid" 2>/dev/null || true
          wait "$mon_pid" 2>/dev/null || true
          mon_pid=""
        fi
      }

      cleanup_remote() {
        stop_monitor
        local child_pids
        child_pids=$(jobs -pr 2>/dev/null || true)
        if [[ -n $child_pids ]]; then
          # shellcheck disable=SC2086
          kill -TERM $child_pids 2>/dev/null || true
        fi
        rm -rf "''${work:-}" 2>/dev/null || true
        if (( in_shell )) && [[ -n ''${script_path:-} ]]; then
          rm -f "$script_path" 2>/dev/null || true
        fi
      }
      trap cleanup_remote EXIT
      trap 'exit 143' INT TERM HUP

      # Isolate Nix eval cache per worker to avoid SQLite lock contention.
      export XDG_CACHE_HOME="$work/cache"
      mkdir -p "$XDG_CACHE_HOME"

      if ! command -v ffmpeg ffprobe jq >/dev/null 2>&1; then
        if (( in_shell )); then
          log "error: ffmpeg, ffprobe, and jq still missing inside nix shell"
          exit 1
        fi
        command -v nix >/dev/null 2>&1 || {
          log "error: missing ffmpeg/ffprobe/jq and nix on remote builder"
          exit 1
        }
        [[ -n $script_path && -r $script_path ]] || {
          log "error: missing worker script path for nix shell re-exec"
          exit 1
        }
        log "tools missing, entering nix shell for ffmpeg/ffprobe/jq (first run may download)"
        rm -rf "''${work:-}" 2>/dev/null || true
        trap - EXIT INT TERM HUP
        exec nix --extra-experimental-features "nix-command flakes" shell \
          nixpkgs#ffmpeg nixpkgs#jq \
          -c bash "$script_path" --in-shell "$script_path" \
          "$crf" "$cq" "$preset" "$allow_nvenc" "$gop" "$pixfmt" "$keep_langs" "$ext"
      fi

      have_nvenc=0
      if (( allow_nvenc )) && [[ -e /dev/nvidiactl ]]; then
        have_nvenc=1
      fi

      log "worker up: pid=$$ cpus=$(nproc) load=$(cut -d' ' -f1-3 /proc/loadavg) in_shell=$in_shell"
      log "ffmpeg: $(ffmpeg -version 2>/dev/null | sed -n 1p)"
      log "settings: crf=$crf cq=$cq preset=$preset pixfmt=$pixfmt gop=$gop ext=$ext nvenc_allowed=$allow_nvenc nvenc_present=$have_nvenc"
      if command -v nvidia-smi >/dev/null 2>&1; then
        log "gpu: $(nvidia-smi --query-gpu=name,utilization.gpu,memory.used,memory.total --format=csv,noheader 2>/dev/null | paste -sd ';' - || echo unknown)"
      fi

      in_file="$work/input.$ext"
      out_file="$work/output.mp4"
      enc_log="$work/ffmpeg.log"
      prog_file="$work/progress"

      # Log growth of a file every 2s (used for the receive phase).
      monitor_growth() {
        local label=$1 file=$2 prev=0 size
        while sleep 2; do
          size=$(stat -c %s "$file" 2>/dev/null || echo 0)
          if (( size != prev )); then
            log "$label: $((size / 1048576)) MiB ($(( (size - prev) / 2 / 1048576 )) MiB/s)"
            prev=$size
          fi
        done
      }

      # Turn ffmpeg's -progress file into percent / fps / speed / ETA lines.
      monitor_encode() {
        local prog=$1 dur_ms=$2 enc=$3 t0=$4
        local blk us fps speed t_ms pct el eta
        while sleep 5; do
          [[ -s $prog ]] || continue
          blk=$(tail -n 30 "$prog" 2>/dev/null || true)
          us=$(sed -n 's/^out_time_us=//p' <<< "$blk" | tail -n1)
          fps=$(sed -n 's/^fps=//p' <<< "$blk" | tail -n1)
          speed=$(sed -n 's/^speed=//p' <<< "$blk" | tail -n1)
          [[ $us =~ ^[0-9]+$ ]] || continue
          t_ms=$(( us / 1000 ))
          if (( dur_ms > 0 && t_ms > 0 )); then
            pct=$(( t_ms * 100 / dur_ms ))
            if (( pct > 100 )); then pct=100; fi
            el=$(( SECONDS - t0 ))
            eta=$(( el * (dur_ms - t_ms) / t_ms ))
            if (( eta < 0 )); then eta=0; fi
            log "$enc: $pct% (t=$((t_ms / 1000))s/$((dur_ms / 1000))s fps=''${fps:-?} speed=''${speed:-?} elapsed=''${el}s eta=$(printf '%02d:%02d' $((eta / 60)) $((eta % 60))))"
          else
            log "$enc: t=$((t_ms / 1000))s fps=''${fps:-?} speed=''${speed:-?}"
          fi
        done
      }

      # ---- receive -------------------------------------------------------
      log "waiting for input stream..."
      t_recv=$SECONDS
      monitor_growth "receiving" "$in_file" & mon_pid=$!
      cat > "$in_file"
      stop_monitor

      if [[ ! -s $in_file ]]; then
        log "error: received empty input stream"
        exit 1
      fi
      in_bytes=$(stat -c %s "$in_file")
      log "received $((in_bytes / 1048576)) MiB in $((SECONDS - t_recv))s"
      echo "__MEDIA_UPLOAD_DONE__" >&2

      # ---- probe ---------------------------------------------------------
      if ! info=$(ffprobe -v error \
        -show_entries format=duration:stream=index,codec_type,codec_name,width,height,channels:stream_tags=language \
        -of json "$in_file" 2>"$enc_log"); then
        log "error: ffprobe failed on streamed input: $(<"$enc_log")"
        exit 1
      fi

      dur_ms=$(jq -r '((.format.duration // "0") | tonumber * 1000 | floor)' <<< "$info")
      log "probe: duration=$((dur_ms / 1000))s video=$(jq -r '[.streams[] | select(.codec_type=="video")][0] | "\(.codec_name) \(.width)x\(.height)"' <<< "$info") audio_streams=$(jq '[.streams[] | select(.codec_type=="audio")] | length' <<< "$info") subtitle_streams=$(jq '[.streams[] | select(.codec_type=="subtitle")] | length' <<< "$info")"

      pick() {
        jq -r --arg t "$1" --arg k "$keep_langs" --argjson fb "$2" '
          [.streams[] | select(.codec_type == $t)] as $all
          | [$all[] | select((.tags.language // "und") as $l
                             | ($k | split(" ") | index($l)) != null)] as $keep
          | (if ($keep | length) > 0 or ($fb | not) then $keep else $all end)[]
          | "\(.index) \(.codec_name) \(.channels // 2)"' <<< "$info"
      }

      map_args=(-map 0:v:0)

      n=0
      while read -r idx codec _; do
        [[ -n $idx ]] || continue
        map_args+=(-map "0:$idx")
        case $codec in
          dts|truehd|flac|pcm_*)
            map_args+=("-c:a:$n" aac "-b:a:$n" 192k "-ac:a:$n" 2)
            log "audio #$idx: $codec -> aac 192k stereo"
            ;;
          *)
            map_args+=("-c:a:$n" copy)
            log "audio #$idx: $codec -> copy"
            ;;
        esac
        n=$((n + 1))
      done < <(pick audio true)

      n=0
      while read -r idx codec _; do
        [[ -n $idx ]] || continue
        case $codec in
          subrip|srt|ass|ssa|mov_text|webvtt|text)
            map_args+=("-map" "0:$idx" "-c:s:$n" mov_text)
            log "subtitle #$idx: $codec -> mov_text"
            n=$((n + 1))
            ;;
          *)
            log "subtitle #$idx: $codec dropped (unsupported in mp4)"
            ;;
        esac
      done < <(pick subtitle false)

      set_v() {
        local enc=$1 qual=$2 pre=$3
        V=()
        case $enc in
          nvenc)
            if (( pixfmt == 10 )); then
              V=(
                -c:v hevc_nvenc -preset p6 -tune hq -rc vbr -cq "$qual" -b:v 0
                -profile:v main10 -pix_fmt p010le
                -spatial-aq 1 -rc-lookahead 32
                -g "$gop" -forced-idr 1 -no-scenecut 1 -strict_gop 1
              )
            else
              V=(
                -c:v hevc_nvenc -preset p6 -tune hq -rc vbr -cq "$qual" -b:v 0
                -profile:v main -pix_fmt nv12
                -spatial-aq 1 -rc-lookahead 32
                -g "$gop" -forced-idr 1 -no-scenecut 1 -strict_gop 1
              )
            fi
            ;;
          x265)
            if (( pixfmt == 10 )); then
              V=(
                -c:v libx265 -crf "$qual" -preset "$pre" -pix_fmt yuv420p10le
                -g "$gop"
                -x265-params "log-level=error:keyint=$gop:min-keyint=$gop:scenecut=0:open-gop=0:repeat-headers=1"
              )
            else
              V=(
                -c:v libx265 -crf "$qual" -preset "$pre" -pix_fmt yuv420p
                -g "$gop"
                -x265-params "log-level=error:keyint=$gop:min-keyint=$gop:scenecut=0:open-gop=0:repeat-headers=1"
              )
            fi
            ;;
        esac
      }

      encode_once() {
        local enc=$1 qual=$2 rc=0 t_enc out_bytes
        rm -f "$out_file" "$enc_log" "$prog_file"
        set_v "$enc" "$qual" "$preset"
        log "encoding with $enc (q=$qual, preset=$preset, pixfmt=$pixfmt)"
        t_enc=$SECONDS

        monitor_encode "$prog_file" "$dur_ms" "$enc" "$t_enc" & mon_pid=$!
        ffmpeg -nostdin -hide_banner -loglevel error -y \
          -progress "$prog_file" -stats_period 5 \
          -i "$in_file" \
          "''${map_args[@]}" \
          "''${V[@]}" \
          -force_key_frames "expr:gte(t,n_forced*2)" \
          -movflags +faststart \
          -f mp4 "$out_file" 2>"$enc_log" || rc=$?
        stop_monitor

        if (( rc == 0 )); then
          out_bytes=$(stat -c %s "$out_file" 2>/dev/null || echo 0)
          log "$enc finished in $((SECONDS - t_enc))s, output $((out_bytes / 1048576)) MiB"
          return 0
        fi
        log "ffmpeg ($enc) exited with status $rc after $((SECONDS - t_enc))s"
        if [[ -s $enc_log ]]; then
          log "ffmpeg ($enc) stderr: $(tr '\n' ' ' < "$enc_log")"
        fi
        return 1
      }

      send_result() {
        local out_bytes
        out_bytes=$(stat -c %s "$out_file")
        log "sending result: $out_bytes bytes ($((out_bytes / 1048576)) MiB, $((out_bytes * 100 / in_bytes))% of input)"
        cat "$out_file"
        log "done, total $((SECONDS - t_start))s"
      }

      if (( have_nvenc )); then
        if encode_once nvenc "$cq"; then
          send_result
          exit 0
        fi
        log "nvenc failed; falling back to x265"
      fi

      encode_once x265 "$crf" || exit 1
      send_result
    '';

    workerB64 = builtins.readFile (
      pkgs.runCommand "media-worker-b64" {
        nativeBuildInputs = [ pkgs.coreutils ];
      } ''
        base64 -w0 ${pkgs.writeText "media-worker.sh" remoteWorkerScript} > "$out"
      ''
    );

    # Terminal dashboard (rich). Reads tab-separated events from a FIFO.
    mediaBuildUi = pkgs.writers.writePython3Bin "media-build-ui" {
      libraries = [ pkgs.python3Packages.rich ];
      flakeIgnore = [ "E" "W" ];
    } (builtins.readFile ./media-build-ui.py);

    mediaBuild = pkgs.writeShellApplication {
      name = "media-build";
      excludeShellChecks = [ "SC2016" "SC2029" "SC2034" ];
      runtimeInputs = with pkgs; [
        ffmpeg jq coreutils findutils gawk openssh procps util-linux mediaBuildUi
      ];
      text = ''
        ROOT="${root}"
        BUILDERS_FILE="${buildersFile}"
        WORKER_B64="${workerB64}"
        UPLOAD_DONE="__MEDIA_UPLOAD_DONE__"

        # Patterns for the status lines the remote worker sends back (UI mode).
        RE_RECV='receiving: ([0-9]+) MiB \(([0-9]+) MiB/s\)'
        RE_GOT='received [0-9]+ MiB in'
        RE_PROBE='probe: duration='
        RE_ENCSTART='encoding with ([a-z0-9]+)'
        RE_ENC='(nvenc|x265): ([0-9]+)% \(t=[0-9]+s/[0-9]+s fps=([^ ]+) speed=([^ ]+) elapsed=[0-9]+s eta=([0-9:]+)\)'
        RE_SEND='sending result: ([0-9]+) bytes'

        # Dashboard state. UI=1 -> events go to fd 9 (FIFO read by media-build-ui)
        # and plain log lines are suppressed from the terminal.
        UI=0
        UI_PID=""
        UI_LOG=""
        MIN_BPS=4000000
        KEEP_LANGS="eng ger deu jpn und"

        # Run-wide state (set in run_command, inherited by worker subshells).
        ACTIVE_RUN_DIR=""
        QUEUE_FILE=""
        LOCK_FILE=""
        RESULTS_DIR=""
        TRANSFER_LOCK=""
        STOPPING=0
        CLEANUP_DONE=0
        declare -a POOL_PIDS=()

        # Per-slot state (each slot is its own subshell, so these are private).
        HAVE_TRANSFER_LOCK=0
        SLOT_TMP=""
        SLOT_ERR_LOG=""
        SLOT_OUT=""
        SLOT_ID=""
        DL_MON_PID=""
        POPPED_REL=""
        declare -a SSH_OPTS=()

        die() { finish_ui; echo "error: $*" >&2; exit 1; }

        # One event per line, tab separated. Lines stay < PIPE_BUF so writes
        # from concurrent slots to the FIFO are atomic.
        emitf() {
          if (( UI )); then
            local IFS=$'\t'
            printf '%s\n' "$*" >&9 2>/dev/null || true
          fi
        }

        log() {
          if (( UI )); then
            local m
            m="$*"
            m=''${m//$'\t'/ }
            m=''${m//$'\n'/ }
            emitf L "''${m:0:3000}"
          else
            echo "[$(date +%H:%M:%S)] $*" >&2
          fi
        }

        # Like echo, but routed into the dashboard log when the UI is active.
        say() {
          if (( UI )); then
            log "$*"
          else
            echo "$*"
          fi
        }

        ev_stage() { emitf T "$SLOT_ID" "$1" "''${2:-}"; }
        ev_prog() { emitf P "$SLOT_ID" "$1" "$2" "''${3:-}"; }

        start_ui() {
          local fifo="$ACTIVE_RUN_DIR/events"
          UI_LOG="/tmp/media-build-$(date +%Y%m%d-%H%M%S).log"
          mkfifo "$fifo"
          media-build-ui --fifo "$fifo" --log "$UI_LOG" &
          UI_PID=$!
          exec 9>"$fifo"
          trap "" PIPE
          UI=1
        }

        finish_ui() {
          if (( UI )); then
            emitf E
            UI=0
            exec 9>&-
            wait "$UI_PID" 2>/dev/null || true
          fi
        }

        # ---- cleanup ------------------------------------------------------

        kill_descendants() {
          local parent=$1 sig=$2 child
          while IFS= read -r child; do
            [[ -n $child ]] || continue
            kill_descendants "$child" "$sig"
            kill -"$sig" "$child" 2>/dev/null || true
          done < <(pgrep -P "$parent" 2>/dev/null || true)
        }

        stop_workers() {
          local p
          for p in "''${POOL_PIDS[@]:-}"; do
            [[ -n $p ]] || continue
            kill_descendants "$p" TERM
            kill -TERM "$p" 2>/dev/null || true
          done
          sleep 0.2
          for p in "''${POOL_PIDS[@]:-}"; do
            [[ -n $p ]] || continue
            kill_descendants "$p" KILL
            kill -KILL "$p" 2>/dev/null || true
            wait "$p" 2>/dev/null || true
          done
          POOL_PIDS=()
        }

        cleanup_local_files() {
          find "$ROOT" -name '.media-build.*' -type f -delete 2>/dev/null || true
          if [[ -n $ACTIVE_RUN_DIR && -d $ACTIVE_RUN_DIR ]]; then
            rm -rf "$ACTIVE_RUN_DIR" 2>/dev/null || true
          fi
        }

        on_signal() {
          local sig=$1 code=$2
          STOPPING=1
          trap - EXIT INT TERM HUP
          if (( CLEANUP_DONE == 0 )); then
            CLEANUP_DONE=1
            log "caught $sig - stopping workers and cleaning up..."
            stop_workers 2>/dev/null
            cleanup_local_files
            finish_ui
          fi
          exit "$code"
        }

        on_exit() {
          STOPPING=1
          if (( CLEANUP_DONE == 0 )); then
            CLEANUP_DONE=1
            stop_workers 2>/dev/null
            cleanup_local_files
            finish_ui
          fi
        }

        trap on_exit EXIT
        trap 'on_signal INT 130' INT
        trap 'on_signal TERM 143' TERM
        trap 'on_signal HUP 129' HUP

        # ---- helpers ------------------------------------------------------

        savings() {
          awk -v a="$1" -v b="$2" 'BEGIN {
            printf "%.0f MiB -> %.0f MiB (saved %.0f MiB, %.1f%%)",
              a / 1048576, b / 1048576, (a - b) / 1048576, (a > 0 ? (a - b) * 100 / a : 0)
          }'
        }

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

        probe_video() {
          ffprobe -v error -select_streams v:0 \
            -show_entries stream=codec_name,pix_fmt,color_transfer,avg_frame_rate:format=bit_rate \
            -of json "$1" | jq -r '
              .streams[0] as $s | .format as $f |
              [
                ($s.codec_name // "unknown"),
                (($f.bit_rate // 0) | tonumber | floor),
                ($s.pix_fmt // ""),
                ($s.color_transfer // ""),
                ($s.avg_frame_rate // "24/1")
              ] | @tsv'
        }

        scan() {
          local f c br pix xfer fps n=0
          while IFS= read -r -d "" f; do
            IFS=$'\t' read -r c br pix xfer fps < <(probe_video "$f")
            awk -v s="$(stat -c %s "$f")" -v c="$c" -v b="$br" -v f="''${f#"$ROOT"/}" 'BEGIN {
              printf "%8.1f MiB | %-6s | %5.1f Mbps | %s\n", s / 1048576, c, b / 1e6, f
            }'
            n=$((n + 1))
          done < <(discover "$@")
          echo "Found $n files."
        }

        # Prints lines sorted by speedFactor desc:
        #   ssh_target<TAB>key_path<TAB>max_jobs<TAB>features_csv
        load_builders() {
          [[ -r $BUILDERS_FILE ]] || die "Cannot read builders file: $BUILDERS_FILE"
          local raw entry uri key jobs speed feats host_part target
          raw=$(<"$BUILDERS_FILE")
          raw=''${raw//;/$'\n'}
          {
            while IFS= read -r entry; do
              entry=$(echo "$entry" | xargs)
              [[ -n $entry ]] || continue
              read -r uri _sys key jobs speed feats _ <<< "$entry"
              [[ -n $uri ]] || continue
              host_part=''${uri#ssh://}
              host_part=''${host_part%%/*}
              target="$host_part"
              [[ $target == *@* ]] || target="remote_build@$target"
              if ! [[ $jobs =~ ^[0-9]+$ ]] || (( jobs < 1 )); then
                jobs=1
              fi
              if ! [[ $speed =~ ^[0-9]+([.][0-9]+)?$ ]]; then
                speed=1
              fi
              feats=''${feats:-}
              printf '%s\t%s\t%s\t%s\t%s\n' "$speed" "$target" "$key" "$jobs" "$feats"
            done <<< "$raw"
          } | sort -t$'\t' -k1,1nr | cut -f2-
        }

        has_feature() {
          local csv=$1 want=$2 item
          local -a items=()
          IFS=',' read -ra items <<< "$csv"
          for item in "''${items[@]}"; do
            [[ $item == "$want" ]] && return 0
          done
          return 1
        }

        # ---- work queue ---------------------------------------------------

        pop_next_job() {
          POPPED_REL=$(
            (
              flock -x 200
              next=""
              if IFS= read -r next < "$QUEUE_FILE"; then
                tail -n +2 "$QUEUE_FILE" > "$QUEUE_FILE.tmp"
                mv -f "$QUEUE_FILE.tmp" "$QUEUE_FILE"
                printf '%s' "$next"
              fi
            ) 200>"$LOCK_FILE"
          )
        }

        # ---- upload serialisation ----------------------------------------
        # Only one slot may upload at a time (shared uplink). The lock is a
        # directory because mkdir is atomic - the old marker-file scheme let
        # several waiters see "no marker" at once and all start together.
        # Released when the remote worker reports the upload is complete, or
        # on any failure / exit path (release is idempotent).

        acquire_transfer_lock() {
          local target=$1 slot=$2 waited=0
          while (( STOPPING == 0 )); do
            if mkdir "$TRANSFER_LOCK" 2>/dev/null; then
              HAVE_TRANSFER_LOCK=1
              return 0
            fi
            if (( waited == 0 )); then
              log "[$target#$slot] waiting for another worker's upload to finish..."
              ev_stage wait
            fi
            waited=$((waited + 1))
            sleep 1
          done
          return 1
        }

        release_transfer_lock() {
          if (( HAVE_TRANSFER_LOCK )); then
            rmdir "$TRANSFER_LOCK" 2>/dev/null || true
            HAVE_TRANSFER_LOCK=0
          fi
        }

        slot_cleanup() {
          stop_download_monitor
          release_transfer_lock
          if [[ -n $SLOT_TMP ]]; then rm -f "$SLOT_TMP"; fi
          if [[ -n $SLOT_ERR_LOG ]]; then rm -f "$SLOT_ERR_LOG"; fi
        }

        # Local progress for the download phase: watch the growing temp file.
        start_download_monitor() {
          local tmp=$1 total=$2 sid=$SLOT_ID
          stop_download_monitor
          (
            prev=0
            while sleep 1; do
              size=$(stat -c %s "$tmp" 2>/dev/null || echo 0)
              pct=$(( total > 0 ? size * 100 / total : 0 ))
              if (( pct > 99 )); then pct=99; fi
              emitf P "$sid" download "$pct" "$(( (size - prev) / 1048576 )) MiB/s"
              prev=$size
            done
          ) &
          DL_MON_PID=$!
        }

        stop_download_monitor() {
          if [[ -n $DL_MON_PID ]]; then
            kill "$DL_MON_PID" 2>/dev/null || true
            wait "$DL_MON_PID" 2>/dev/null || true
            DL_MON_PID=""
          fi
        }

        # Turn the remote worker's status lines into dashboard events.
        parse_remote_line() {
          local line=$1 orig=$2 tmp=$3 pct
          if [[ $line =~ $RE_ENC ]]; then
            ev_prog encode "''${BASH_REMATCH[2]}" "''${BASH_REMATCH[1]} ''${BASH_REMATCH[3]}fps ''${BASH_REMATCH[4]} eta ''${BASH_REMATCH[5]}"
          elif [[ $line =~ $RE_RECV ]]; then
            pct=$(( BASH_REMATCH[1] * 1048576 * 100 / (orig > 0 ? orig : 1) ))
            if (( pct > 99 )); then pct=99; fi
            ev_prog upload "$pct" "''${BASH_REMATCH[2]} MiB/s"
          elif [[ $line =~ $RE_GOT ]]; then
            ev_prog upload 100 ""
          elif [[ $line =~ $RE_PROBE ]]; then
            ev_stage encode "probing"
          elif [[ $line =~ $RE_ENCSTART ]]; then
            ev_stage encode "''${BASH_REMATCH[1]}"
            ev_prog encode 0 "''${BASH_REMATCH[1]}"
          elif [[ $line =~ $RE_SEND ]]; then
            ev_stage download ""
            start_download_monitor "$tmp" "''${BASH_REMATCH[1]}"
          fi
        }

        backup_original() {
          local dest=$1 bak=$2 bak_tmp
          mkdir -p "$(dirname "$bak")"
          if [[ -e $bak ]]; then
            return 0
          fi
          bak_tmp=$(mktemp "$(dirname "$bak")/.bak.XXXXXX")
          if ! cp -p "$dest" "$bak_tmp"; then
            rm -f "$bak_tmp"
            return 1
          fi
          mv -f "$bak_tmp" "$bak"
        }

        # ---- remote streaming --------------------------------------------

        # ssh stdin  = source video
        # ssh stdout = encoded MP4 -> $tmp
        # ssh stderr = worker status lines -> piped through the loop below,
        #              logged live and kept in $err_log.
        # NOTE the redirection order "2>&1 >file": stderr must be duplicated
        # onto the pipe BEFORE stdout is pointed at the file. The previous
        # ">file 2>&1" sent the status text (and the upload-done marker) into
        # the MP4 instead, so the transfer lock was never released.
        stream_remote_encode() {
          local src=$1 tmp=$2 err_log=$3 remote_cmd=$4 target=$5 slot=$6 orig_size=$7
          local rc_file ssh_rc=1 line t_up
          rc_file=$(mktemp "$ACTIVE_RUN_DIR/ssh-rc.XXXXXX")
          : > "$err_log"
          t_up=$SECONDS

          while IFS= read -r line; do
            (( STOPPING == 0 )) || break
            if [[ $line == "$UPLOAD_DONE" ]]; then
              release_transfer_lock
              ev_prog upload 100 ""
              log "[$target#$slot] upload complete in $((SECONDS - t_up))s, transfer slot released"
              continue
            fi
            printf '%s\n' "$line" >> "$err_log"
            log "[$target#$slot] $line"
            if (( UI )); then
              parse_remote_line "$line" "$orig_size" "$tmp"
            fi
          done < <(
            rc=0
            ssh "''${SSH_OPTS[@]}" "$target" "$remote_cmd" < "$src" 2>&1 > "$tmp" || rc=$?
            printf '%s\n' "$rc" > "$rc_file"
          )

          release_transfer_lock
          stop_download_monitor
          if [[ -s $rc_file ]]; then
            ssh_rc=$(<"$rc_file")
          fi
          rm -f "$rc_file"
          if (( ssh_rc == 0 )); then
            ev_prog download 100 ""
          fi
          log "[$target#$slot] ssh exited rc=$ssh_rc, received $(stat -c %s "$tmp" 2>/dev/null || echo 0) bytes"
          return "$ssh_rc"
        }

        record() {
          printf '%s\t%s\t%s\t%s\n' "$1" "$2" "$3" "$4" >> "$SLOT_OUT"
          emitf D "$SLOT_ID" "$1" "$4" "$2" "$3"
        }

        discard_tmp() {
          if [[ -n $SLOT_TMP ]]; then rm -f "$SLOT_TMP"; fi
          SLOT_TMP=""
        }

        process_slot() {
          local target=$1 key=$2 slot=$3 crf=$4 cq=$5 preset=$6 cpu_only=$7
          local rel src ext c br pix xfer fps gop pixfmt allow_nvenc
          local dest final bak orig_size new_size probe_err
          local remote_args remote_cmd slot_failed=0
          local -a worker_args=()

          SLOT_OUT=$8
          SLOT_ID="$target#$slot"
          SLOT_TMP=""
          SLOT_ERR_LOG=""
          HAVE_TRANSFER_LOCK=0

          trap slot_cleanup EXIT
          trap 'STOPPING=1; exit 143' INT TERM HUP

          SSH_OPTS=()
          if [[ -n $key && -r $key ]]; then
            SSH_OPTS+=(-i "$key")
          fi
          SSH_OPTS+=(
            -T
            -o BatchMode=yes
            -o ConnectTimeout=5
            -o ServerAliveInterval=15
            -o ServerAliveCountMax=3
          )

          allow_nvenc=1
          if (( cpu_only )); then
            allow_nvenc=0
          fi

          : > "$SLOT_OUT"
          emitf W "$SLOT_ID"

          while (( STOPPING == 0 )); do
            pop_next_job
            rel="$POPPED_REL"
            [[ -n $rel ]] || break

            src="$ROOT/$rel"
            emitf S "$SLOT_ID" "$rel" "$(stat -c %s "$src" 2>/dev/null || echo 0)"
            if [[ ! -f $src ]]; then
              log "[$target#$slot] missing source: $rel"
              record "$rel" 0 0 failed
              slot_failed=1
              continue
            fi

            IFS=$'\t' read -r c br pix xfer fps < <(probe_video "$src")
            orig_size=$(stat -c %s "$src")
            ext=''${rel##*.}
            if [[ -z $ext ]]; then
              ext="mkv"
            fi

            gop=$(awk -v r="$fps" 'BEGIN {
              f = (r ~ /\// && split(r, a, "/") == 2 && a[2] > 0) ? a[1] / a[2] : (r + 0 > 0 ? r + 0 : 24);
              g = int(f * 2 + 0.5);
              print (g < 12 ? 12 : g);
            }')

            if [[ $pix == *10* || $pix == *12* || $xfer == "smpte2084" || $xfer == "arib-std-b67" ]]; then
              pixfmt=10
            else
              pixfmt=8
            fi

            dest="$src"
            final="''${dest%.*}.mp4"
            bak="$ROOT/backups/$rel"
            SLOT_TMP=$(mktemp "$(dirname "$dest")/.media-build.XXXXXX")
            SLOT_ERR_LOG=$(mktemp "$ACTIVE_RUN_DIR/ssh-err.XXXXXX")

            worker_args=(
              "$crf" "$cq" "$preset" "$allow_nvenc"
              "$gop" "$pixfmt" "$KEEP_LANGS" "$ext"
            )
            printf -v remote_args '%q ' "''${worker_args[@]}"
            remote_cmd="sf=\$(mktemp /tmp/media-worker.XXXXXX.sh) && printf '%s' '$WORKER_B64' | base64 -d > \"\$sf\" && exec bash \"\$sf\" \"\$sf\" $remote_args"

            acquire_transfer_lock "$target" "$slot" || break

            ev_stage upload
            log "[$target#$slot] streaming $rel ($((orig_size / 1048576)) MiB, ''${pixfmt}-bit, gop=$gop)"

            if ! stream_remote_encode "$src" "$SLOT_TMP" "$SLOT_ERR_LOG" "$remote_cmd" "$target" "$slot" "$orig_size"; then
              (( STOPPING == 0 )) || break
              log "[$target#$slot] FAILED remote encode for $rel"
              if [[ -s $SLOT_ERR_LOG ]]; then
                log "[$target#$slot] last remote output: $(tail -n 20 "$SLOT_ERR_LOG" | tr '\n' ' ')"
              fi
              discard_tmp
              record "$rel" "$orig_size" 0 failed
              slot_failed=1
              continue
            fi
            rm -f "$SLOT_ERR_LOG"
            SLOT_ERR_LOG=""

            (( STOPPING == 0 )) || break

            ev_stage verify "ffprobe"
            ev_prog verify 10 "ffprobe"

            if [[ ! -s $SLOT_TMP ]]; then
              log "[$target#$slot] INVALID output for $rel (empty output file)"
              discard_tmp
              record "$rel" "$orig_size" 0 failed
              slot_failed=1
              continue
            fi

            if ! probe_err=$(ffprobe -v error "$SLOT_TMP" 2>&1); then
              log "[$target#$slot] INVALID output for $rel (ffprobe failed: $probe_err, bytes=$(stat -c %s "$SLOT_TMP" 2>/dev/null || echo 0))"
              discard_tmp
              record "$rel" "$orig_size" 0 failed
              slot_failed=1
              continue
            fi

            ev_prog verify 40 "size check"
            new_size=$(stat -c %s "$SLOT_TMP")
            if (( new_size >= orig_size )); then
              log "[$target#$slot] SKIP deploy (not smaller): $rel ($(savings "$orig_size" "$new_size"))"
              discard_tmp
              record "$rel" "$orig_size" "$orig_size" skipped
              continue
            fi

            ev_prog verify 60 "backup"
            if ! backup_original "$dest" "$bak"; then
              log "[$target#$slot] FAILED backup for $rel"
              discard_tmp
              record "$rel" "$orig_size" 0 failed
              slot_failed=1
              continue
            fi

            ev_prog verify 80 "deploy"
            # Preserve permissions and owner/group from the original.
            chmod --reference="$dest" "$SLOT_TMP"
            chown --reference="$dest" "$SLOT_TMP" 2>/dev/null || chgrp --reference="$dest" "$SLOT_TMP" 2>/dev/null || true

            mv -f "$SLOT_TMP" "$final"
            SLOT_TMP=""
            if [[ $final != "$dest" ]]; then
              rm -f "$dest"
            fi

            log "[$target#$slot] DONE $rel: $(savings "$orig_size" "$new_size")"
            record "$rel" "$orig_size" "$new_size" deployed
          done

          emitf X "$SLOT_ID"

          return "$slot_failed"
        }

        # ---- pool ---------------------------------------------------------

        run_pool() {
          local crf=$1 cq=$2 preset=$3 cpu_only=$4 max_slots=$5
          local target key jobs feats slot idx total_slots=0 rc=0 p
          POOL_PIDS=()

          while IFS=$'\t' read -r target key jobs feats; do
            if (( !cpu_only )) && ! has_feature "$feats" "nvidia-gpu"; then
              log "skipping builder $target (missing nvidia-gpu feature; features='$feats')"
              continue
            fi
            for ((slot = 1; slot <= jobs; slot++)); do
              if (( max_slots > 0 && total_slots >= max_slots )); then
                break
              fi
              idx="''${#POOL_PIDS[@]}"
              total_slots=$((total_slots + 1))
              process_slot "$target" "$key" "$slot" "$crf" "$cq" "$preset" \
                "$cpu_only" "$RESULTS_DIR/$idx" &
              POOL_PIDS+=("$!")
            done
          done < <(load_builders)

          (( ''${#POOL_PIDS[@]} > 0 )) || die "No eligible builders found in $BUILDERS_FILE"
          log "launched ''${#POOL_PIDS[@]} worker slot(s)"

          for p in "''${POOL_PIDS[@]}"; do
            if ! wait "$p"; then
              rc=1
            fi
          done
          POOL_PIDS=()
          return "$rc"
        }

        validate_inputs() {
          local crf=$1 cq=$2 preset=$3 max_slots=$4 paths_count=$5
          if ! [[ $crf =~ ^[0-9]+$ ]] || (( crf > 51 )); then
            die "Invalid CRF (0-51)"
          fi
          if ! [[ $cq =~ ^[0-9]+$ ]] || (( cq > 51 )); then
            die "Invalid CQ (0-51)"
          fi
          if ! [[ $preset =~ ^[a-z0-9_-]+$ ]]; then
            die "Invalid preset"
          fi
          if ! [[ $max_slots =~ ^[0-9]+$ ]]; then
            die "Invalid --slots value"
          fi
          if (( paths_count == 0 )); then
            die "Specify at least one path under $ROOT"
          fi
        }

        run_command() {
          local crf=23 cq=26 preset=medium force=0 cpu_only=0 max_slots=0 ui_req=0 a
          local -a paths=()
          for a in "$@"; do
            case $a in
              --crf=*) crf=''${a#--crf=} ;;
              --cq=*) cq=''${a#--cq=} ;;
              --preset=*) preset=''${a#--preset=} ;;
              --slots=*) max_slots=''${a#--slots=} ;;
              --force) force=1 ;;
              --cpu-only) cpu_only=1 ;;
              --ui) ui_req=1 ;;
              -*) die "Unknown option: $a" ;;
              *) paths+=("$a") ;;
            esac
          done

          validate_inputs "$crf" "$cq" "$preset" "$max_slots" "''${#paths[@]}"

          local f rel c br pix xfer fps count=0
          ACTIVE_RUN_DIR=$(mktemp -d /tmp/media-run.XXXXXX)
          QUEUE_FILE="$ACTIVE_RUN_DIR/queue"
          LOCK_FILE="$ACTIVE_RUN_DIR/lock"
          RESULTS_DIR="$ACTIVE_RUN_DIR/results"
          TRANSFER_LOCK="$ACTIVE_RUN_DIR/transfer.lock"
          mkdir -p "$RESULTS_DIR"
          : > "$QUEUE_FILE"

          if (( ui_req )); then
            if [[ -t 1 && -t 2 ]]; then
              start_ui
            else
              echo "warning: --ui needs a terminal, falling back to plain log output" >&2
            fi
          fi

          while IFS= read -r -d "" f; do
            rel=$(realpath --relative-to="$ROOT" "$f")
            IFS=$'\t' read -r c br pix xfer fps < <(probe_video "$f")
            if [[ $c == hevc || $c == av1 ]] && (( br < MIN_BPS )) && (( !force )); then
              say "SKIP:   $rel ($c, $((br / 1000)) kbps)"
              continue
            fi
            echo "$rel" >> "$QUEUE_FILE"
            emitf Q "$rel" "$(stat -c %s "$f")"
            count=$((count + 1))
          done < <(discover "''${paths[@]}")

          if (( count == 0 )); then
            say "Nothing to transcode."
            return 0
          fi
          say "Queued $count file(s) for SSH streaming transcode."

          local pool_rc=0
          run_pool "$crf" "$cq" "$preset" "$cpu_only" "$max_slots" || pool_rc=1

          local res r_rel a_sz b_sz status ta=0 tb=0 done_n=0 fail_n=0 skip_n=0
          for res in "$RESULTS_DIR"/*; do
            [[ -s $res ]] || continue
            while IFS=$'\t' read -r r_rel a_sz b_sz status; do
              case $status in
                deployed)
                  ta=$((ta + a_sz))
                  tb=$((tb + b_sz))
                  done_n=$((done_n + 1))
                  ;;
                skipped) skip_n=$((skip_n + 1)) ;;
                failed) fail_n=$((fail_n + 1)) ;;
              esac
            done < "$res"
          done

          say "Summary: deployed $done_n, skipped $skip_n, failed $fail_n. Savings: $(savings "$ta" "$tb")"
          return "$pool_rc"
        }

        case "''${1:-help}" in
          scan)
            shift
            scan "$@"
            ;;
          encode|transcode)
            shift
            run_command "$@"
            ;;
          *)
            echo "Usage:"
            echo "  media-build scan PATH..."
            echo "  media-build encode [--crf=23] [--cq=26] [--preset=medium] [--slots=N] [--force] [--cpu-only] [--ui] PATH..."
            ;;
        esac
      '';
    };
  in {
    environment.systemPackages = [ mediaBuild mediaBuildUi ];
  };
}
