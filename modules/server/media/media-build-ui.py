"""media-build-ui: terminal dashboard for media-build.

Reads tab-separated events (one per line) from a FIFO / stdin:

  Q  rel  size                      file queued
  W  slot                           worker slot started
  S  slot  rel  size                slot picked up a file
  T  slot  stage  [info]            stage became active (wait|upload|encode|download|verify)
  P  slot  stage  pct  [info]       stage progress
  D  slot  rel  status  orig  new   file finished (deployed|skipped|failed)
  X  slot                           slot has no more work
  L  message                        log line
  E                                 end of run
"""
import argparse
import os
import re
import signal
import sys
import threading
import time
from collections import OrderedDict, deque

from rich.console import Console
from rich.layout import Layout
from rich.live import Live
from rich.panel import Panel
from rich.table import Table
from rich.text import Text

STAGES = [
    ("upload", "Upload"),
    ("encode", "Encode"),
    ("download", "Download"),
    ("verify", "Verify / deploy"),
]
ORDER = [k for k, _ in STAGES]
LABEL = dict(STAGES)
STATE_COLOR = {"active": "cyan", "done": "green", "failed": "red"}


def to_int(s):
    try:
        return int(s)
    except (TypeError, ValueError):
        return 0


def fmt_size(n):
    n = float(n)
    if n >= 1073741824:
        return f"{n / 1073741824:.2f} GiB"
    return f"{n / 1048576:.0f} MiB"


def fmt_dur(s):
    s = int(s)
    h, r = divmod(s, 3600)
    m, sec = divmod(r, 60)
    return f"{h}:{m:02d}:{sec:02d}" if h else f"{m:02d}:{sec:02d}"


def short(rel):
    return os.path.splitext(os.path.basename(rel))[0]


def log_style(msg):
    if re.search(r"FAILED|INVALID|error|Error|exited with status", msg):
        return "red"
    if re.search(r"SKIP|waiting for another|falling back|dropped|caught", msg):
        return "yellow"
    if "DONE" in msg:
        return "green"
    if re.search(r"% \(t=|receiving:|downloading:", msg):
        return "grey50"
    return None


class Stage:
    def __init__(self):
        self.state = "pending"  # pending | waiting | active | done | failed
        self.pct = 0
        self.info = ""


class Worker:
    def __init__(self, sid):
        self.sid = sid
        self.label = sid.split("@")[-1]
        self.file = None
        self.size = 0
        self.t0 = None
        self.t1 = None
        self.finished = False
        self.result = ""
        self.stages = {k: Stage() for k in ORDER}

    def start(self, rel, size):
        self.file = rel
        self.size = size
        self.t0 = time.time()
        self.t1 = None
        self.result = ""
        self.stages = {k: Stage() for k in ORDER}

    def elapsed(self):
        if self.t0 is None:
            return 0
        return (self.t1 or time.time()) - self.t0


class State:
    def __init__(self, logpath):
        self.lock = threading.Lock()
        self.t0 = time.time()
        self.waiting = OrderedDict()
        self.workers = OrderedDict()
        self.done = []
        self.log = deque(maxlen=20000)
        self.counts = {"deployed": 0, "skipped": 0, "failed": 0}
        self.saved = 0
        self.ended = False
        self.logfile = open(logpath, "a", buffering=1, errors="replace")

    def worker(self, sid):
        if sid not in self.workers:
            self.workers[sid] = Worker(sid)
        return self.workers[sid]

    def add_log(self, msg):
        ts = time.strftime("%H:%M:%S")
        self.log.append((ts, msg))
        self.logfile.write(f"{ts} {msg}\n")

    def handle(self, line):
        f = line.rstrip("\n").split("\t")

        def arg(i):
            return f[i] if len(f) > i else ""

        k = f[0]
        with self.lock:
            if k == "Q":
                self.waiting[arg(1)] = to_int(arg(2))
            elif k == "L":
                self.add_log(arg(1))
            elif k == "W":
                self.worker(arg(1))
            elif k == "S":
                w = self.worker(arg(1))
                w.start(arg(2), to_int(arg(3)))
                self.waiting.pop(arg(2), None)
            elif k == "T":
                self.on_stage(self.worker(arg(1)), arg(2), arg(3))
            elif k == "P":
                w = self.worker(arg(1))
                if arg(2) in w.stages:
                    s = w.stages[arg(2)]
                    if s.state in ("pending", "waiting"):
                        s.state = "active"
                    s.pct = max(0, min(100, to_int(arg(3))))
                    s.info = arg(4)
            elif k == "D":
                self.on_done(self.worker(arg(1)), arg(2), arg(3), to_int(arg(4)), to_int(arg(5)))
            elif k == "X":
                w = self.worker(arg(1))
                w.finished = True
            elif k == "E":
                self.ended = True

    def on_stage(self, w, stage, info):
        if stage == "wait":
            s = w.stages["upload"]
            s.state = "waiting"
            s.info = info or "queued behind another upload"
            return
        if stage not in w.stages:
            return
        idx = ORDER.index(stage)
        for name in ORDER[:idx]:
            s = w.stages[name]
            if s.state != "failed":
                s.state = "done"
                s.pct = 100
        s = w.stages[stage]
        s.state = "active"
        if info:
            s.info = info

    def on_done(self, w, rel, status, orig, new):
        w.t1 = time.time()
        w.result = status
        if status == "failed":
            hit = False
            for name in ORDER:
                s = w.stages[name]
                if s.state in ("active", "waiting"):
                    s.state = "failed"
                    hit = True
            if not hit:
                w.stages["upload"].state = "failed"
        else:
            for name in ORDER:
                s = w.stages[name]
                s.state = "done"
                s.pct = 100
            if status == "skipped":
                w.stages["verify"].info = "not smaller - kept original"
            else:
                w.stages["verify"].info = f"{fmt_size(orig)} -> {fmt_size(new)}"
                self.saved += max(0, orig - new)
        self.counts[status] = self.counts.get(status, 0) + 1
        self.done.append((time.time(), rel, status, orig, new, w.elapsed()))


# ---- renderables -----------------------------------------------------------

class Header:
    def __init__(self, st):
        self.st = st

    def __rich_console__(self, console, options):
        st = self.st
        with st.lock:
            running = sum(1 for w in st.workers.values() if w.file and not w.result)
            t = Text(no_wrap=True, overflow="ellipsis")
            t.append(" media-build ", style="bold white on blue")
            t.append(f"  elapsed {fmt_dur(time.time() - st.t0)}")
            t.append(f"   running {running}", style="cyan")
            t.append(f"   waiting {len(st.waiting)}", style="yellow")
            t.append(f"   deployed {st.counts['deployed']}", style="green")
            t.append(f"   skipped {st.counts['skipped']}", style="grey70")
            t.append(f"   failed {st.counts['failed']}", style="red" if st.counts["failed"] else "grey70")
            t.append(f"   saved {fmt_size(st.saved)}", style="bold green")
        yield t


class Tail:
    """Newest log lines, as many as fit in the available height."""

    def __init__(self, st):
        self.st = st

    def __rich_console__(self, console, options):
        h = options.height or 10
        with self.st.lock:
            lines = list(self.st.log)[-h:]
        for ts, msg in lines:
            yield Text(f"{ts} {msg}", style=log_style(msg) or "", no_wrap=True, overflow="ellipsis")


def stage_cell(stage, bw):
    bar = Text(no_wrap=True, overflow="ellipsis")
    if stage.state == "pending":
        bar.append("─" * bw, style="grey30")
        bar.append("  --", style="grey30")
    elif stage.state == "waiting":
        bar.append("waiting…", style="yellow")
    else:
        color = STATE_COLOR[stage.state]
        filled = int(bw * stage.pct / 100)
        bar.append("━" * filled, style=color)
        bar.append("─" * (bw - filled), style="grey30")
        bar.append(f" {stage.pct:3d}%", style=color)
        if stage.state == "done":
            bar.append(" ✔", style="green")
        elif stage.state == "failed":
            bar.append(" ✘", style="red")
    info = Text(stage.info, style="grey62", no_wrap=True, overflow="ellipsis")
    return Text("\n").join([bar, info])


class Workers:
    def __init__(self, st):
        self.st = st

    def __rich_console__(self, console, options):
        width = options.max_width
        bw = max(6, width // 4 - 10)
        with self.st.lock:
            workers = list(self.st.workers.values())
            if not workers:
                yield Text("starting workers…", style="grey62")
                return
            for w in workers:
                title = Text(no_wrap=True, overflow="ellipsis")
                if w.file is None:
                    title.append(f"○ {w.label}  ", style="bold")
                    title.append("finished, no more work" if w.finished else "starting", style="grey62")
                else:
                    if w.result == "failed":
                        dot, style = "✘", "red"
                    elif w.result:
                        dot, style = "✔", "green"
                    else:
                        dot, style = "●", "cyan"
                    title.append(f"{dot} {w.label}  ", style=f"bold {style}")
                    title.append(short(w.file))
                    title.append(f"  {fmt_size(w.size)}  {fmt_dur(w.elapsed())}", style="grey62")
                    if w.finished:
                        title.append("  (no more work)", style="grey62")
                yield title
                grid = Table.grid(expand=True, padding=(0, 1))
                for _ in STAGES:
                    grid.add_column(ratio=1, no_wrap=True)
                grid.add_row(*[stage_cell(w.stages[k], bw) for k in ORDER])
                yield grid


class WaitingList:
    def __init__(self, st):
        self.st = st

    def __rich_console__(self, console, options):
        h = options.height or 10
        with self.st.lock:
            items = list(self.st.waiting.items())
        if not items:
            yield Text("queue empty", style="grey62")
            return
        shown = items if len(items) <= h else items[: h - 1]
        grid = Table.grid(expand=True)
        grid.add_column(width=2)
        grid.add_column(ratio=1, no_wrap=True, overflow="ellipsis")
        grid.add_column(justify="right", no_wrap=True)
        for rel, size in shown:
            grid.add_row("·", short(rel), fmt_size(size))
        yield grid
        if len(items) > len(shown):
            yield Text(f"+ {len(items) - len(shown)} more", style="grey62")


class DoneList:
    def __init__(self, st):
        self.st = st

    def __rich_console__(self, console, options):
        h = options.height or 10
        with self.st.lock:
            items = self.st.done[-h:]
        if not items:
            yield Text("nothing finished yet", style="grey62")
            return
        grid = Table.grid(expand=True)
        grid.add_column(width=2)
        grid.add_column(ratio=1, no_wrap=True, overflow="ellipsis")
        grid.add_column(justify="right", no_wrap=True)
        for _, rel, status, orig, new, el in items:
            if status == "deployed":
                pct = (orig - new) * 100 / orig if orig else 0
                grid.add_row(
                    Text("✔", style="green"),
                    short(rel),
                    Text(f"{fmt_size(orig)} → {fmt_size(new)}  -{pct:.0f}%  {fmt_dur(el)}", style="green"),
                )
            elif status == "skipped":
                grid.add_row(Text("↷", style="yellow"), short(rel), Text("skipped (not smaller)", style="yellow"))
            else:
                grid.add_row(Text("✘", style="red"), short(rel), Text("failed", style="red"))
        yield grid


class Dashboard:
    def __init__(self, st, logpath):
        self.st = st
        self.logpath = logpath

    def __rich_console__(self, console, options):
        st = self.st
        with st.lock:
            n = max(1, len(st.workers))
            n_wait = len(st.waiting)
            n_done = len(st.done)
        root = Layout()
        root.split_column(
            Layout(Header(st), name="header", size=1),
            Layout(
                Panel(Tail(st), title="Log", subtitle=self.logpath, subtitle_align="right", border_style="blue"),
                name="log", ratio=3, minimum_size=6,
            ),
            Layout(Panel(Workers(st), title="Workers", border_style="cyan"), name="workers", size=3 * n + 2),
            Layout(name="lists", ratio=2, minimum_size=5),
        )
        root["lists"].split_row(
            Layout(Panel(WaitingList(st), title=f"Waiting ({n_wait})", border_style="yellow"), name="waiting"),
            Layout(Panel(DoneList(st), title=f"Done ({n_done})", border_style="green"), name="done"),
        )
        yield root


def final_report(console, st, logpath):
    with st.lock:
        c = dict(st.counts)
        saved = st.saved
        failed = [r for _, r, s, *_ in st.done if s == "failed"]
        left = list(st.waiting)
    console.print(
        f"[bold]media-build finished[/bold] in {fmt_dur(time.time() - st.t0)}: "
        f"[green]{c['deployed']} deployed[/green], [yellow]{c['skipped']} skipped[/yellow], "
        f"[red]{c['failed']} failed[/red], saved [bold green]{fmt_size(saved)}[/bold green]"
    )
    for rel in failed:
        console.print(f"  [red]✘[/red] {rel}")
    if left:
        console.print(f"  [yellow]{len(left)} file(s) were never started[/yellow]")
    console.print(f"full log: {logpath}")


def reader(path, st):
    try:
        src = sys.stdin if path in (None, "-") else open(path, "r", errors="replace")
        for line in src:
            try:
                st.handle(line)
            except Exception as exc:  # never let a bad line kill the UI
                with st.lock:
                    st.add_log(f"ui: bad event {line.strip()!r}: {exc}")
    finally:
        with st.lock:
            st.ended = True


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--fifo", help="event source (default: stdin)")
    ap.add_argument("--log", help="file receiving the full log")
    args = ap.parse_args()

    # The parent handles Ctrl-C and tells us to stop with an E event.
    signal.signal(signal.SIGINT, signal.SIG_IGN)

    logpath = args.log or f"/tmp/media-build-{time.strftime('%Y%m%d-%H%M%S')}.log"
    st = State(logpath)
    threading.Thread(target=reader, args=(args.fifo, st), daemon=True).start()

    console = Console()
    with Live(Dashboard(st, logpath), console=console, screen=True, refresh_per_second=8):
        while not st.ended:
            time.sleep(0.1)
    final_report(console, st, logpath)


if __name__ == "__main__":
    main()
