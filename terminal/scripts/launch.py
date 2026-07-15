#!/usr/bin/env -S uv run
# /// script
# dependencies = [
#   "cytoolz",
#   "prompt_toolkit",
# ]
# ///

import json
import os
import shutil
import sqlite3
import ssl
import subprocess
import sys
import tempfile
import time
import urllib.parse
import urllib.request
from contextlib import closing

from toolz import curry, pipe
from toolz.curried import map

try:
    ssl._create_default_https_context = ssl._create_unverified_context
except AttributeError:
    pass

ALIASES = {
    "лву": "kde",
    "пщ": "go",
    "тшч": "nix",
    "ек": "tr",
    "нек": "ytr",
    "фт": "an",
    "шьп": "img",
    "ку": "re",
    "ву": "de",
    "йц": "qw",
    "вк": "dr",
    "вг": "du",
    "пше": "git",
    "тп": "ng",
    "2ср": "2ch",
    "ц": "w",
    "кум": "rev",
    "ыр": "sh",
    "цщ": "wo",
    "иу": "be",
    "ы": "s",
    "ывщ": "sdo",
    "мл": "vk",
    "ьфтпф": "manga",
    "йз": "qp",
    "фд": "al",
    "фк": "ar",
    "фка": "arf",
    "фр": "ah",
}


def static_url(url):
    return lambda _: [url]


def search_url(template, default):
    return lambda text: (
        [template.format(urllib.parse.quote(text))] if text else [default]
    )


def run_local_cmd(cmd_list):
    def _handler(_):
        subprocess.run(cmd_list)
        sys.exit(0)

    return _handler


def parse_input(text: str) -> tuple:
    parts = text.strip().split(" ", 1)
    return (parts[0], parts[1] if len(parts) > 1 else "")


def resolve_alias(parsed: tuple) -> tuple:
    cmd, rest = parsed
    return (ALIASES.get(cmd, cmd), rest)


def format_arena_entries(json_data: dict):
    return [
        f"{e.get('title', '').replace(chr(10), ' ')}\t{e.get('id', '')}"
        for e in json_data.get("entries", [])
    ]


def format_ddgr_entries(json_data: list):
    return [
        f"{i.get('title', '')}\t{i.get('url', '')}\t{i.get('abstract', '')}"
        for i in json_data
    ]


def extract_arena_url(fzf_line: str) -> str:
    return f"https://arena.ai/c/{fzf_line.split(chr(9))[1].strip()}"


def extract_ddgr_url(fzf_line: str) -> str:
    return fzf_line.split(chr(9))[1].strip()


def get_user_input(_) -> str:
    args_input = " ".join(sys.argv[1:]).strip()
    if args_input:
        return args_input

    from prompt_toolkit import PromptSession
    from prompt_toolkit.formatted_text import HTML
    from prompt_toolkit.history import FileHistory

    data_dir = os.path.expanduser("~/.var/.local/share/my_launcher")
    os.makedirs(data_dir, exist_ok=True)
    history_file = os.path.join(data_dir, "history.txt")

    session = PromptSession(
        history=FileHistory(history_file),
        vi_mode=True,
    )

    try:
        return session.prompt(HTML("<ansigreen>Search: </ansigreen>")).strip()
    except (KeyboardInterrupt, EOFError):
        return ""


@curry
def run_fzf(preview_cmd: str, items: list) -> list:
    if not items:
        return []
    cmd = [
        "fzf",
        "--delimiter",
        "\t",
        "--with-nth",
        "1",
        "--preview",
        preview_cmd,
        "--preview-window=top:50%:wrap",
    ]
    p = subprocess.Popen(cmd, stdin=subprocess.PIPE, stdout=subprocess.PIPE, text=True)
    out, _ = p.communicate(input="\n".join(items))
    return [line for line in out.strip().split("\n") if line]


def fetch_arena_api(_):
    db_path = os.path.expanduser(
        os.environ.get("XDG_DATA_HOME", "~/.local/share")
        + "/qutebrowser/webengine/Cookies"
    )
    if not os.path.exists(db_path):
        raise Exception("Cookie DB not found")

    with tempfile.NamedTemporaryFile(delete=False) as tmp:
        shutil.copy2(db_path, tmp.name)

    try:
        with closing(sqlite3.connect(tmp.name)) as conn:
            cur = conn.cursor()
            cur.execute(
                "SELECT name || '=' || value FROM cookies WHERE host_key LIKE '%arena.ai%' AND value != '';"
            )
            cookie = "; ".join([r[0] for r in cur.fetchall()])

        req = urllib.request.Request(
            "https://arena.ai/api/history/unified?limit=50&includeArchived=false",
            headers={"cookie": cookie},
        )
        with urllib.request.urlopen(req) as resp:
            return json.loads(resp.read().decode())
    finally:
        os.remove(tmp.name)


def fetch_ddgr_api(query: str):
    res = subprocess.run(
        ["ddgr", "-n", "25", "--noua", "--json", "--noprompt", query],
        capture_output=True,
        text=True,
    )
    return json.loads(res.stdout) if res.returncode == 0 else []


def spawn_browser(urls: list):
    browser = os.environ.get("BROWSER", "xdg-open")
    wm_spawn = os.environ.get("WM_SPAWN", "niri msg action spawn-sh --")
    for url in urls:
        subprocess.run(f'{wm_spawn} "{browser} \\"{url}\\""', shell=True)


def handle_arena(_):
    try:
        return pipe(
            None,
            fetch_arena_api,
            format_arena_entries,
            run_fzf(
                'printf "\033[1;32mID:\033[0m %s\n\n\033[1;33mЗаголовок:\033[0m %s\n" "{2}" "{1}"'
            ),
            map(extract_arena_url),
            list,
        )
    except Exception as e:
        print(f"Arena error: {e}")
        time.sleep(2)
        return []


def handle_fallback(query: str):
    return pipe(
        query,
        fetch_ddgr_api,
        format_ddgr_entries,
        run_fzf(
            'printf "\033[1;32mURL:\033[0m %s\n\n\033[1;33mDescription:\033[0m %s\n" "{2}" "{3}"'
        ),
        map(extract_ddgr_url),
        list,
    )


ROUTES = {
    "go": static_url("https://aistudio.google.com/prompts/new_chat"),
    "nix": search_url(
        "https://search.nixos.org/packages?channel=unstable&query={}",
        "https://search.nixos.org/packages?channel=unstable",
    ),
    "tr": search_url(
        "https://translate.google.com/?hl=en&text={}", "https://translate.google.com/"
    ),
    "ytr": search_url(
        "https://translate.yandex.com/?source_lang=en&target_lang=ru&text={}",
        "https://translate.yandex.com/",
    ),
    "an": search_url(
        "https://annas-archive.gl/search?q={}", "https://annas-archive.gl/"
    ),
    "img": static_url("https://gelbooru.com/index.php?page=post&s=list&tags=all"),
    "re": search_url("https://old.reddit.com/search?q={}", "https://old.reddit.com/"),
    "de": static_url("https://chat.deepseek.com/"),
    "qw": static_url("https://chat.qwen.ai/"),
    "dr": static_url("https://www.tldraw.com/"),
    "du": static_url("https://duckduckgo.com/?q=DuckDuckGo+AI+Chat&ia=chat&duckai=1"),
    "git": search_url("https://github.com/search?q={}", "https://github.com/"),
    "ng": static_url("https://www.newgrounds.com/"),
    "2ch": static_url("https://2ch.su/"),
    "w": static_url("https://web.whatsapp.com/"),
    "rev": search_url(
        "https://context.reverso.net/translation/english-russian/{}",
        "https://context.reverso.net/translation/english-russian/",
    ),
    "sh": static_url(
        "https://npi-tu.ru/schedule/schedule.html?for=student&faculty=2&year=3&group=%D0%9F%D0%9E%D0%92%D0%B0"
    ),
    "wo": static_url("https://docs.google.com/document/u/0/"),
    "be": static_url("https://rostov-na-donu.beeline.ru/customers/products/elk/"),
    "s": static_url("https://sdo.npi-tu.ru/"),
    "sdo": run_local_cmd(["sdo"]),
    "kde": run_local_cmd("kdeconnect-app"),
    "npi": static_url("https://dec.srspu.ru/Ved/"),
    "vk": static_url("https://vk.com/im"),
    "manga": static_url("https://mangadex.org/titles/follows"),
    "qp": static_url("https://posemy.art/quick-poses/"),
    "al": static_url("https://alice.yandex.ru/"),
    "yt": static_url("https://www.youtube.com/feed/downloads"),
    "ar": static_url("https://arena.ai/?mode=direct"),
    "arf": static_url("https://arena.ai/direct?m=flash"),
    "helltaker": static_url(
        "https://www.youtube.com/playlist?list=PLzxkyQKtgmo9A0Gq-YS1vvxqlLNgB8vhU"
    ),
    "van": static_url(
        "https://www.youtube.com/playlist?list=PL5pycTgSAvaB4EE1h_bZOQl2DHiHFy6_g"
    ),
    "ah": handle_arena,
}


def route_request(parsed: tuple) -> list:
    cmd, rest = parsed
    handler = ROUTES.get(cmd)
    return handler(rest) if handler else handle_fallback(f"{cmd} {rest}".strip())


def main():
    pipe(
        None,
        get_user_input,
        lambda x: sys.exit(0) if not x else x,
        parse_input,
        resolve_alias,
        route_request,
        spawn_browser,
    )


if __name__ == "__main__":
    main()
