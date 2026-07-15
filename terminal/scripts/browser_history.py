#!/usr/bin/env -S uv run
# /// script
# dependencies = [
#   "cytoolz",
# ]
# ///

import os
import shutil
import sqlite3
import subprocess
import sys
import tempfile
from contextlib import closing

from toolz import curry, pipe
from toolz.curried import filter, map


def get_query_arg(_) -> str:
    return " ".join(sys.argv[1:]).strip()


def fetch_history(_):
    db_path = os.path.expanduser("~/.local/share/qutebrowser/history.sqlite")

    if not os.path.exists(db_path):
        print(f"Error: DB not found at {db_path}")
        sys.exit(1)

    with tempfile.NamedTemporaryFile(delete=False) as tmp:
        shutil.copy2(db_path, tmp.name)

    try:
        with closing(sqlite3.connect(tmp.name)) as conn:
            cur = conn.cursor()
            cur.execute("""
                SELECT url, title 
                FROM History 
                GROUP BY url 
                ORDER BY MAX(atime) DESC 
                LIMIT 20000;
            """)
            return cur.fetchall()
    finally:
        os.remove(tmp.name)


@curry
def run_fzf(query: str, items: list) -> list[str]:
    if not items:
        return []

    cmd = [
        "fzf",
        "--reverse",
        "--delimiter",
        "\t",
        "--with-nth",
        "2,1",
    ]
    if query:
        cmd.append(f"--query={query}")

    p = subprocess.Popen(cmd, stdin=subprocess.PIPE, stdout=subprocess.PIPE, text=True)
    out, _ = p.communicate(input="\n".join(items))

    return [line for line in out.strip().split("\n") if line]


def extract_url(fzf_selections: list[str]) -> list[str]:
    if not fzf_selections:
        return []
    return [line.split("\t")[0].strip() for line in fzf_selections]


def spawn_browser(urls: list[str]):
    if not urls:
        sys.exit(0)

    browser = os.environ.get("BROWSER", "xdg-open")
    wm_spawn = os.environ.get("WM_SPAWN", "niri msg action spawn-sh --")

    for url in urls:
        safe_url = url.replace('"', '\\"')
        cmd = f'{wm_spawn} "{browser} \\"{safe_url}\\""'

        subprocess.run(cmd, shell=True)


def main():
    pipe(
        None,
        fetch_history,
        filter(lambda row: "blank" not in str(row[0])),
        map(lambda row: f"{row[0]}\t{(row[1] or 'No Title').replace(chr(10), ' ')}"),
        list,
        run_fzf(get_query_arg(None)),
        extract_url,
        spawn_browser,
    )


if __name__ == "__main__":
    main()
