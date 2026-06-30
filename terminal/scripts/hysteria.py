#!/usr/bin/env -S uv run
# /// script
# dependencies = [
#   "pyyaml",
#   "cytoolz",
# ]
# ///


import json
import subprocess

import yaml
from toolz import get_in, pipe
from toolz.curried import filter, first


def read_clipboard(_=None) -> str:
    return subprocess.run(
        ["wl-paste"], capture_output=True, text=True, check=True
    ).stdout.strip()


def write_clipboard(text: str) -> str:
    subprocess.run(["wl-copy"], input=text, text=True, check=True)
    return text


def print_result(text: str) -> str:
    print("-" * 30)
    print(text)
    print("-" * 30)
    return text


def find_by_protocol(protocol: str, items: list) -> dict:
    try:
        return pipe(items, filter(lambda x: x.get("protocol") == protocol), first)
    except StopIteration:
        return {}


def extract_obfs(stream_settings: dict) -> dict:
    try:
        salamander_node = pipe(
            get_in(["finalmask", "udp"], stream_settings, default=[]),
            filter(lambda x: x.get("type") == "salamander"),
            first,
        )
        return {
            "obfs": {
                "type": "salamander",
                "salamander": {
                    "password": get_in(["settings", "password"], salamander_node)
                },
            }
        }
    except StopIteration:
        return {}


def build_hysteria_dict(xray_json: dict) -> dict:
    outbounds = xray_json.get("outbounds", [])
    inbounds = xray_json.get("inbounds", [])

    hy_outbound = find_by_protocol("hysteria", outbounds)
    if not hy_outbound:
        raise ValueError("В JSON не найден outbound с протоколом 'hysteria'")

    socks_inbound = find_by_protocol("socks", inbounds)
    stream = hy_outbound.get("streamSettings", {})

    base_config = {
        "server": f"{get_in(['settings', 'address'], hy_outbound)}:{get_in(['settings', 'port'], hy_outbound)}",
        "auth": get_in(["hysteriaSettings", "auth"], stream),
        "tls": {"sni": get_in(["tlsSettings", "serverName"], stream)},
        "socks5": {"listen": f"127.0.0.1:{socks_inbound.get('port', 10808)}"},
        "quic": {"congestion": "bbr"},
    }

    return {**base_config, **extract_obfs(stream)}


def dict_to_yaml(data: dict) -> str:
    """Превращает словарь в YAML строку"""
    return yaml.dump(
        data, sort_keys=False, allow_unicode=True, default_flow_style=False
    )


def main():
    try:
        pipe(
            None,
            read_clipboard,
            json.loads,
            build_hysteria_dict,
            dict_to_yaml,
            write_clipboard,
            print_result,
        )
    except Exception as e:
        print(f"❌ Ошибка конвейера: {e}")


if __name__ == "__main__":
    main()
