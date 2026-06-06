#!/usr/bin/env bash

if ! command -v rip &>/dev/null; then
  echo "Error: 'rip' utility is not installed. Run: cargo install rm-improved" >&2
  exit 1
fi

VERBOSE=0
if [[ "$1" == "-v" || "$1" == "--verbose" ]]; then
  VERBOSE=1
  shift
fi

args=("$@")
CURRENT_DIR="$(pwd)"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

STAGE_DIR=$(mktemp -d "/tmp/vidir_stage_XXXXXX")
UNDO_FILE="/tmp/vidir_undo_${TIMESTAMP}.sh"
LOG_FILE="/tmp/vidir_log_${TIMESTAMP}.log"

orig_file=$(mktemp)
edit_file=$(mktemp)

counter=0
declare -A orig_paths
orig_order=()

undo_stages=()
undo_restores=()
undo_new_items=()

emergency_rollback() {
  echo -e "\n[ABORT] Emergency rollback initiated. Returning files..." >&2
  if [[ -n "$STAGE_DIR" && -d "$STAGE_DIR" ]]; then
    for id in "${!orig_paths[@]}"; do
      if [[ -e "$STAGE_DIR/$id" || -L "$STAGE_DIR/$id" ]]; then
        command mkdir -p -- "$(dirname "${orig_paths[$id]}")"
        command mv -n -- "$STAGE_DIR/$id" "${orig_paths[$id]}" 2>/dev/null
      fi
    done
    command rmdir -- "$STAGE_DIR" 2>/dev/null
  fi
  command rm -f -- "$orig_file" "$edit_file"
  exit 1
}
trap emergency_rollback INT TERM

add_file() {
  local file="$1"
  file="${file#./}"

  [[ -z "$file" || "$file" == "." ]] && return

  if [[ "$file" == *$'\n'* ]]; then
    echo "CRITICAL ERROR: File contains a newline character (\n):" >&2
    echo "$file" >&2
    exit 1
  fi

  file="${file%/}"

  ((counter++))
  orig_paths[$counter]="$file"
  orig_order+=("$counter")
  printf "%d\t%s\n" "$counter" "$file"
}

{
  if [ ! -t 0 ] && [ ! -c /dev/stdin ]; then
    while IFS= read -r line; do add_file "$line"; done
  else
    [[ ${#args[@]} -eq 0 ]] && args=(".")
    while IFS= read -r -d '' line; do add_file "$line"; done < <(find "${args[@]}" -maxdepth 1 -print0)
  fi
} >"$orig_file"

if [[ $counter -eq 0 ]]; then
  command rmdir -- "$STAGE_DIR" 2>/dev/null
  command rm -f -- "$orig_file" "$edit_file"
  exit 0
fi

cp -- "$orig_file" "$edit_file"
${EDITOR:-nvim} "$edit_file"

if cmp -s -- "$orig_file" "$edit_file"; then
  command rmdir -- "$STAGE_DIR" 2>/dev/null
  command rm -f -- "$orig_file" "$edit_file"
  exit 0
fi

declare -A edit_first_seen
declare -a copies
declare -A copies_src
declare -a new_items

while IFS= read -r line; do
  line="${line%$'\r'}"
  [[ -z "$line" ]] && continue

  if [[ "$line" =~ ^([0-9]+)($'\t'|[[:space:]]+)(.*)$ ]]; then
    id="${BASH_REMATCH[1]}"
    path="${BASH_REMATCH[3]}"
    path="${path%/}"

    if [[ -z "$path" ]]; then
      echo "Error: Empty path for ID $id. Aborting." >&2
      command rmdir -- "$STAGE_DIR" 2>/dev/null
      command rm -f -- "$orig_file" "$edit_file"
      exit 1
    fi

    if [[ -z "${edit_first_seen[$id]}" ]]; then
      edit_first_seen[$id]="$path"
    else
      copies+=("$id:$path")
      copies_src[$id]=1
    fi
  else
    if [[ "$line" =~ ^[[:space:]]+(.*)$ ]]; then
      clean_line="${BASH_REMATCH[1]}"
    else
      clean_line="$line"
    fi
    [[ -n "$clean_line" ]] && new_items+=("$clean_line")
  fi
done <"$edit_file"

deletes=()
moves=()
declare -A move_targets
declare -A refs
declare -A deleted_paths_map

for id in "${orig_order[@]}"; do
  orig="${orig_paths[$id]}"
  if [[ -z "${edit_first_seen[$id]}" ]]; then
    deletes+=("$id")
    deleted_paths_map["$orig"]=1
  else
    new_path="${edit_first_seen[$id]}"
    if [[ "$orig" != "$new_path" ]] || [[ -n "${copies_src[$id]}" ]]; then
      moves+=("$id")
      move_targets[$id]="$new_path"
    fi
  fi
done

for item in "${new_items[@]}"; do
  clean_item="${item%/}"
  if [[ -n "${deleted_paths_map[$clean_item]}" ]]; then
    echo "CRITICAL ERROR: You removed the ID for '$clean_item' but left the path!" >&2
    command rmdir -- "$STAGE_DIR" 2>/dev/null
    command rm -f -- "$orig_file" "$edit_file"
    exit 1
  fi
done

echo "Vidir session log: $(date)" >"$LOG_FILE"
cat <<EOF >"$UNDO_FILE"
#!/usr/bin/env bash
cd $(printf "%q" "$CURRENT_DIR") || exit 1
STAGE_DIR="\$(mktemp -d "/tmp/vidir_stage_XXXXXX")"
EOF
chmod +x -- "$UNDO_FILE"

for id in "${deletes[@]}"; do
  target="${orig_paths[$id]}"
  [[ $VERBOSE -eq 1 ]] && printf "rip -- %q\n" "$target"
  command rip -- "$target" >/dev/null 2>&1
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] Deleted: $target (sent to rip)" >>"$LOG_FILE"
done

tmp_stage_sort=$(mktemp)
for id in "${!move_targets[@]}"; do
  depth=$(tr -dc '/' <<<"${orig_paths[$id]}" | wc -c)
  echo "$depth $id" >>"$tmp_stage_sort"
done
stage_indices=($(command sort -n -r "$tmp_stage_sort" | awk '{print $2}'))
command rm -f -- "$tmp_stage_sort"

for id in "${stage_indices[@]}"; do
  src="${orig_paths[$id]}"
  if [[ -e "$src" || -L "$src" ]]; then
    [[ $VERBOSE -eq 1 ]] && printf "mv -- %q %q\n" "$src" "$STAGE_DIR/$id"
    command mv -- "$src" "$STAGE_DIR/$id"
  fi
done

restore_actions=()
for id in "${moves[@]}"; do
  restore_actions+=("$id:M:${move_targets[$id]}")
  refs[$id]=$((${refs[$id]:-0} + 1))
done
for copy in "${copies[@]}"; do
  id="${copy%%:*}"
  dst="${copy#*:}"
  restore_actions+=("$id:C:$dst")
  refs[$id]=$((${refs[$id]:-0} + 1))
done

tmp_sort=$(mktemp)
for idx in "${!restore_actions[@]}"; do
  action="${restore_actions[$idx]}"
  target="${action#*:*:}"
  depth=$(tr -dc '/' <<<"$target" | wc -c)
  echo "$depth ${#target} $idx" >>"$tmp_sort"
done
sorted_indices=($(command sort -n -k1,1 -k2,2 "$tmp_sort" | awk '{print $3}'))
command rm -f -- "$tmp_sort"

trap '' INT TERM

for idx in "${sorted_indices[@]}"; do
  action="${restore_actions[$idx]}"
  id="${action%%:*}"
  rest="${action#*:}"
  target="${rest#*:}"

  [[ $VERBOSE -eq 1 ]] && printf "mkdir -p -- %q\n" "$(dirname "$target")"
  command mkdir -p -- "$(dirname "$target")"
  refs[$id]=$((refs[$id] - 1))

  if [[ -e "$target" || -L "$target" ]]; then
    echo "WARNING: Path '$target' already exists! Overwrite rejected." >&2
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] Conflict: Failed to process '${orig_paths[$id]}' -> '$target'." >>"$LOG_FILE"
    continue
  fi

  if [[ ${refs[$id]} -eq 0 ]]; then
    [[ $VERBOSE -eq 1 ]] && printf "mv -- %q %q\n" "$STAGE_DIR/$id" "$target"
    if command mv -- "$STAGE_DIR/$id" "$target"; then
      undo_restores+=("command mv -- $(printf %q "$target") \"\$STAGE_DIR/$id\"")
      undo_stages+=("command mkdir -p -- $(printf %q "$(dirname "${orig_paths[$id]}")")")
      undo_stages+=("command mv -n -- \"\$STAGE_DIR/$id\" $(printf %q "${orig_paths[$id]}")")
      echo "[$(date +'%Y-%m-%d %H:%M:%S')] Moved: ${orig_paths[$id]} -> $target" >>"$LOG_FILE"
    else
      echo "Error moving to $target" >&2
    fi
  else
    [[ $VERBOSE -eq 1 ]] && printf "cp -a -- %q %q\n" "$STAGE_DIR/$id" "$target"
    if command cp -a -- "$STAGE_DIR/$id" "$target"; then
      undo_restores+=("command rm -rf -- $(printf %q "$target")")
      echo "[$(date +'%Y-%m-%d %H:%M:%S')] Copied: ${orig_paths[$id]} -> $target" >>"$LOG_FILE"
    else
      echo "Error copying to $target" >&2
    fi
  fi
done

for item in "${new_items[@]}"; do
  if [[ "$item" == */ ]]; then
    [[ $VERBOSE -eq 1 ]] && printf "mkdir -p -- %q\n" "$item"
    if command mkdir -p -- "$item"; then
      echo "[$(date +'%Y-%m-%d %H:%M:%S')] Created dir: $item" >>"$LOG_FILE"
      undo_new_items+=("command rm -rf -- $(printf %q "${item%/}")")
    fi
  else
    [[ $VERBOSE -eq 1 ]] && printf "mkdir -p -- %q\ntouch -- %q\n" "$(dirname "$item")" "$item"
    if command mkdir -p -- "$(dirname "$item")" && command touch -- "$item"; then
      echo "[$(date +'%Y-%m-%d %H:%M:%S')] Created file: $item" >>"$LOG_FILE"
      undo_new_items+=("command rm -f -- $(printf %q "$item")")
    fi
  fi
done

undo_cleanups=()
for id in "${deletes[@]}" "${moves[@]}"; do
  dir="$(dirname "${orig_paths[$id]}")"
  if [[ "$dir" != "." && "$dir" != "/" ]]; then
    [[ $VERBOSE -eq 1 ]] && printf "rmdir -p -- %q 2>/dev/null\n" "$dir"
    command rmdir -p -- "$dir" 2>/dev/null
  fi
done

for id in "${moves[@]}"; do
  dir="$(dirname "${move_targets[$id]}")"
  [[ "$dir" != "." && "$dir" != "/" ]] && undo_cleanups+=("command rmdir -p -- $(printf %q "$dir") 2>/dev/null")
done

{
  for cmd in "${undo_new_items[@]}"; do echo "$cmd"; done
  for ((i = ${#undo_restores[@]} - 1; i >= 0; i--)); do echo "${undo_restores[$i]}"; done
  for cmd in "${undo_stages[@]}"; do echo "$cmd"; done
  for cmd in "${undo_cleanups[@]}"; do echo "$cmd"; done
  echo "command rmdir -- \"\$STAGE_DIR\" 2>/dev/null"
} >>"$UNDO_FILE"

command rmdir -- "$STAGE_DIR" 2>/dev/null
if [[ -d "$STAGE_DIR" ]]; then
  echo -e "\n!!! CRITICAL NOTICE !!!\nSome operations failed. Unmoved files are in:\n$STAGE_DIR" >&2
else
  command rm -f -- "$orig_file" "$edit_file"
fi

if [[ $VERBOSE -eq 0 ]]; then
  echo "Done. Undo: $UNDO_FILE | Log: $LOG_FILE"
fi
