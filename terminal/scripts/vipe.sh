#!/usr/bin/env bash
set -euo pipefail

TMP=$(mktemp) || {
  echo "cannot create tempfile" >&2
  exit 1
}
trap 'rm -f "$TMP"' EXIT

cat >"$TMP" || {
  echo "write temp failed: $!" >&2
  exit 1
}

exec 3>&1

exec 0</dev/tty || {
  echo "reopen stdin failed" >&2
  exit 1
}
exec 1>/dev/tty || {
  echo "reopen stdout failed" >&2
  exit 1
}

editor=("vi")
if [[ -x "/usr/bin/editor" ]]; then
  editor=("/usr/bin/editor")
fi

if [[ -n "${EDITOR:-}" ]]; then
  read -r -a editor <<<"$EDITOR"
fi

if [[ -n "${VISUAL:-}" ]]; then
  read -r -a editor <<<"$VISUAL"
fi

if ! "${editor[@]}" "$@" "$TMP" 3>&-; then
  echo "${editor[*]} exited nonzero, aborting" >&2
  exit 1
fi

cat "$TMP" >&3 || {
  echo "write failure" >&2
  exit 1
}

exec 3>&-

