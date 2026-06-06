#!/usr/bin/env bash

set -euo pipefail

show_help() {
  echo "Usage: $0 [options] <file1> [file2] [file3] ..."
  echo "Options:"
  echo "  -d, --dry-run    Show changes without actually renaming"
  echo "  -h, --help       Show this help message"
  echo "  --               Option separator (all arguments after are treated as files)"
  exit 0
}

DRY_RUN=false
FILES=()

while [[ $# -gt 0 ]]; do
  case "$1" in
  -d | --dry-run)
    DRY_RUN=true
    shift
    ;;
  -h | --help)
    show_help
    ;;
  --)
    shift
    FILES+=("$@")
    break
    ;;
  -*)
    echo "Error: Unknown option $1" >&2
    echo "Use $0 --help for usage." >&2
    exit 1
    ;;
  *)
    FILES+=("$1")
    shift
    ;;
  esac
done

if [ ${#FILES[@]} -eq 0 ]; then
  echo "Error: No files specified for processing." >&2
  echo "Usage: $0 [options] <file1> [file2] ..."
  exit 1
fi

if [ "$DRY_RUN" = true ]; then
  echo "=== DRY RUN MODE ==="
fi

for filepath in "${FILES[@]}"; do
  if [ ! -f "$filepath" ]; then
    echo "Warning: File '$filepath' does not exist or is a directory. Skipping." >&2
    continue
  fi

  if [ "$(realpath "$filepath")" = "$(realpath "$0")" ]; then
    continue
  fi

  dir=$(dirname "$filepath")
  filename=$(basename "$filepath")

  if [[ "$filename" == *.* ]]; then
    ext="${filename##*.}"
    basename="${filename%.*}"
  else
    ext=""
    basename="$filename"
  fi

  cleaned=$(echo "$basename" | sed -E 's/\([^)]*\)//g')

  cleaned=$(echo "$cleaned" | tr '[:upper:]' '[:lower:]')

  cleaned=$(echo "$cleaned" | tr ' _.' '-')

  cleaned=$(echo "$cleaned" | sed -E 's/[^a-z0-9а-яё-]//g')

  cleaned=$(echo "$cleaned" | sed -E 's/-+/-/g' | sed -E 's/^-//; s/-$//')

  if [ -z "$cleaned" ]; then
    cleaned="file"
  fi

  hash_code=$(md5sum "$filepath" | cut -c1-8)

  if [ -n "$ext" ]; then
    ext_lower=$(echo "$ext" | tr '[:upper:]' '[:lower:]')
    new_filename="${cleaned}_${hash_code}.${ext_lower}"
  else
    new_filename="${cleaned}_${hash_code}"
  fi

  if [ "$filename" = "$new_filename" ]; then
    continue
  fi

  new_filepath="$dir/$new_filename"

  if [ "$DRY_RUN" = true ]; then
    echo "[DRY RUN] '$filename' -> '$new_filename'"
  else
    mv -n "$filepath" "$new_filepath"
    echo "Renamed: '$filename' -> '$new_filename'"
  fi
done
