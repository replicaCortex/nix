#!/usr/bin/env bash

PREVIEW_SCRIPT="${DOTFILES}/terminal/scripts/fzf-preview.sh"
PIPE_PATH=$("$PREVIEW_SCRIPT")

IMAGE_VIEWER="nsxiv -ta"
HISTORY_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/pick_action_history.txt"

cleanup() {
  if [ -p "$PIPE_PATH" ]; then
    echo "CLOSE_PREVIEW_WINDOW" >"$PIPE_PATH" 2>/dev/null
    rm -f "$PIPE_PATH"
  fi
}
trap cleanup EXIT

format_args() {
  local result=""
  for arg in "$@"; do
    result+=" '${arg//\'/\'\\\'\'}'"
  done
  echo "$result"
}

IPC_BIND="focus:execute-silent(bash -c 'f=\"\$1\"; f=\"\${f% : *}\"; realpath \"\$f\" > \"\$2\" 2>/dev/null' _ {} \"$PIPE_PATH\")"
HIST_IPC_BIND="focus:execute-silent(bash -c 'paths=\"\$1\"; first=\"\${paths%%|*}\"; realpath \"\$first\" > \"\$2\" 2>/dev/null' _ {3} \"$PIPE_PATH\")"

TMSU_DB="$HOME/.tmsu/db"

mkdir -p "$(dirname "$HISTORY_FILE")"

mapfile -t output < <(
  {
    sqlite3 "$TMSU_DB" "
      SELECT file.directory || '/' || file.name || ' : ' || group_concat(tag.name, ' ') 
      FROM file 
      JOIN file_tag ON file.id = file_tag.file_id 
      JOIN tag ON file_tag.tag_id = tag.id 
      GROUP BY file.id;
    " 2>/dev/null

    fd -t f -E vault
  } | LC_ALL=C sort -u | awk -F ' : ' '{ if(NF==2) print $1 "\033[38;2;146;131;116m : \033[38;2;131;165;152m" $2 "\033[0m"; else print $0 }' | fzf --print-query \
    --expect=ctrl-z,ctrl-f,alt-f,ctrl-x,alt-x,ctrl-r,alt-r,ctrl-g,alt-g,ctrl-v,alt-v,ctrl-a,alt-a,ctrl-t,alt-t,ctrl-e,alt-e,ctrl-y,alt-y,ctrl-d,alt-d,ctrl-o,alt-o \
    --bind="$IPC_BIND" \
    --header="C-z: history | Ctrl: action on selected | Alt: action on ALL matched
c/a-o: openImg | c/a-f: PureRef | c/a-r: vidir | c/a-t: editTags | c/a-g: aiTags 
c/a-v: move | c/a-x: rip | c/a-e: collage | c/a-y: copy | c/a-a: copyPath | c-d: dir"
)

[[ ${#output[@]} -eq 0 ]] && exit 0

query="${output[0]}"
key="${output[1]}"
results=("${output[@]:2}")

[[ -z "$key" && ${#results[@]} -eq 0 ]] && exit 0

# cleanup

PARENT_PROC=$(ps -o comm= -p $PPID 2>/dev/null)
PARENT_PROC="${PARENT_PROC// /}"

case "$PARENT_PROC" in
bash | zsh | sh | fish) SPAWNED_MODE=false ;;
*) SPAWNED_MODE=true ;;
esac

get_abs_path() {
  local p="${1% : *}"
  if [[ "$p" == /* ]]; then
    echo "$p"
  elif [ -e "$PWD/$p" ]; then
    echo "$PWD/$p"
  elif [ -e "$HOME/$p" ]; then
    echo "$HOME/$p"
  else
    echo "$p"
  fi
}

save_action_history() {
  local action_name="$1"
  local sim_key="$2"
  shift 2
  local files=("$@")

  [[ ${#files[@]} -eq 0 ]] && return

  local -a abs_files
  for f in "${files[@]}"; do
    abs_files+=("$(get_abs_path "$f")")
  done

  local joined_paths
  joined_paths=$(
    IFS='|'
    echo "${abs_files[*]}"
  )
  local new_entry="${action_name} ::: ${sim_key} ::: ${joined_paths}"

  (
    flock -x 200 || return
    local temp_file
    temp_file=$(mktemp)

    echo "$new_entry" >"$temp_file"

    if [ -f "$HISTORY_FILE" ]; then
      cat "$HISTORY_FILE" >>"$temp_file"
    fi

    awk '!seen[$0]++' "$temp_file" | head -n 100 >"${HISTORY_FILE}.tmp"
    mv "${HISTORY_FILE}.tmp" "$HISTORY_FILE"
    rm -f "$temp_file"
  ) 200>"${HISTORY_FILE}.lock"
}

execute_action() {
  local act_key="$1"
  shift
  local act_results=("$@")

  if [[ "$act_key" == alt-* ]]; then
    if [ -z "$query" ]; then
      notify-send "TMSU" "Type a tag query to apply action to ALL files!"
      return 1
    fi

    local clean_query="${query//!/ not }"
    [[ "$clean_query" == !* ]] && clean_query="not ${clean_query:1}"

    mapfile -t act_results < <(tmsu --database="${TMSU_DB}" files "$clean_query" 2>/dev/null)

    if [ ${#act_results[@]} -eq 0 ]; then
      notify-send "TMSU" "No files found for query: $query"
      return 0
    fi

    act_key="ctrl-${act_key#alt-}"
  fi

  if [ "$act_key" = "ctrl-r" ]; then
    declare -a selected_files
    for result in "${act_results[@]}"; do
      result=$(get_abs_path "$result")
      [ -e "$result" ] && selected_files+=("$result")
    done

    if [ ${#selected_files[@]} -gt 0 ]; then
      save_action_history "[Vidir]" "ctrl-r" "${selected_files[@]}"
      "${DOTFILES}/terminal/scripts/vidir.sh" "${selected_files[@]}"
      notify-send "Vidir" "Rename ${#selected_files[@]} file(s)"
    fi
    return 0
  fi

  if [ "$act_key" = "ctrl-o" ]; then
    declare -a images
    for res in "${act_results[@]}"; do
      res=$(get_abs_path "$res")
      if [ -f "$res" ]; then
        case "${res##*/}" in
        *.[Pp][Nn][Gg] | *.[Jj][Pp][Gg] | *.[Jj][Pp][Ee][Gg] | *.[Ww][Ee][Bb][Pp] | *.[Tt][Ii][Ff][Ff] | *.[Gg][Ii][Ff])
          images+=("$res")
          ;;
        esac
      fi
    done

    if [ ${#images[@]} -gt 0 ]; then
      save_action_history "[Open Image]" "ctrl-o" "${images[@]}"
      if [ "${SPAWNED_MODE}" = true ]; then
        ${WM_SPAWN} "${IMAGE_VIEWER} $(format_args "${images[@]}")"
      else
        ${IMAGE_VIEWER} "${images[@]}" &
      fi
    else
      notify-send "fzf-open" "No images found/selected."
    fi
    return 0
  fi

  if [ "$act_key" = "ctrl-g" ]; then
    save_action_history "[AI Tags]" "ctrl-g" "${act_results[@]}"
    for result in "${act_results[@]}"; do
      result=$(get_abs_path "$result")
      ext="${result##*.}"
      ext_lower="${ext,,}"

      case "$ext_lower" in
      pdf | epub | fb2 | mobi)
        tags=$("${DOTFILES}/terminal/scripts/parsers/book-groq.sh" "$result")
        ;;
      mp4 | mkv | avi | webm)
        tags=$("${DOTFILES}/terminal/scripts/parsers/video-groq.sh" "$result")
        ;;
      esac

      if [ -n "$tags" ]; then
        echo "$tags" | xargs tmsu --database="${TMSU_DB}" tag "$result"
        notify-send "AI Tags" "Tags added for $(basename "$result")"
      fi
    done
    return 0
  fi

  if [ "$act_key" = "ctrl-t" ]; then
    save_action_history "[Edit Tags]" "ctrl-t" "${act_results[@]}"
    EDIT_TAGS_FILE=$(mktemp /tmp/tmsu_edit_tags_XXXXXX.txt)

    for result in "${act_results[@]}"; do
      raw_path=$(get_abs_path "$result")

      if [ -f "$raw_path" ]; then
        current_tags=$(tmsu --database="${TMSU_DB}" tags "$raw_path" 2>/dev/null | sed -n 's/^.*: //p')
        echo "$current_tags | $raw_path" >>"$EDIT_TAGS_FILE"
      fi
    done

    if [ -s "$EDIT_TAGS_FILE" ]; then
      ${EDITOR} "$EDIT_TAGS_FILE"

      while IFS='|' read -r tags filepath <&3; do
        tags="${tags#"${tags%%[![:space:]]*}"}"
        tags="${tags%"${tags##*[![:space:]]}"}"
        filepath="${filepath#"${filepath%%[![:space:]]*}"}"
        filepath="${filepath%"${filepath##*[![:space:]]}"}"

        [ -z "$filepath" ] || [ ! -f "$filepath" ] && continue

        existing_active_tags=$(tmsu --database="${TMSU_DB}" tags "$filepath" 2>/dev/null | sed -n 's/^.*: //p')
        if [ -n "$existing_active_tags" ]; then
          echo "$existing_active_tags" | xargs tmsu --database="${TMSU_DB}" untag "$filepath" 2>/dev/null
        fi

        if [ -n "$tags" ]; then
          echo "$tags" | xargs tmsu --database="${TMSU_DB}" tag "$filepath" 2>/dev/null
        fi
      done 3<"$EDIT_TAGS_FILE"

      notify-send "TMSU" "Tags updated"
    fi
    rm -f "$EDIT_TAGS_FILE"
    return 0
  fi

  if [ -z "$act_key" ] || [ "$act_key" = "enter" ]; then
    save_action_history "[Default Open]" "enter" "${act_results[@]}"
    declare -a videos images docs others dirs

    for res in "${act_results[@]}"; do
      res=$(get_abs_path "$res")

      if [ -d "$res" ]; then
        dirs+=("$res")
        continue
      fi

      ext="${res##*.}"
      ext="${ext,,}"

      case "$ext" in
      mkv | mp4 | avi | mov | webm | mp3 | m4a | opus) videos+=("$res") ;;
      png | jpg | jpeg | webp | tiff | gif) images+=("$res") ;;
      pdf | epub | fb2 | mobi | djvu | azw | azw3) docs+=("$res") ;;
      *) others+=("$res") ;;
      esac
    done

    if [ ${#videos[@]} -gt 0 ]; then
      if [ "${SPAWNED_MODE}" = true ]; then
        ${WM_SPAWN} "${VIDEO_VIEWER:-mpv} $(format_args "${videos[@]}")"
      else
        ${VIDEO_VIEWER:-mpv} "${videos[@]}" &
      fi
    fi

    if [ ${#images[@]} -gt 0 ]; then
      if [ "${SPAWNED_MODE}" = true ]; then
        ${WM_SPAWN} "${IMAGE_VIEWER} $(format_args "${images[@]}")"
      else
        ${IMAGE_VIEWER} "${images[@]}" &
      fi
    fi

    if [ ${#docs[@]} -gt 0 ]; then
      if [ "${SPAWNED_MODE}" = true ]; then
        for doc in "${docs[@]}"; do ${WM_SPAWN} "${DOCUMENT_VIEWER} '${doc//\'/\'\\\'\'}'"; done
      else
        for doc in "${docs[@]}"; do ${DOCUMENT_VIEWER} "$doc" & done
      fi
    fi

    if [ ${#others[@]} -gt 0 ]; then
      if [ "${SPAWNED_MODE}" = true ]; then
        for other in "${others[@]}"; do
          ${WM_SPAWN} "${TERMINAL} -e ${EDITOR} $(format_args "${other}")"
        done
      else
        ${EDITOR} "${others[@]}"
      fi
    fi

    if [ ${#dirs[@]} -gt 0 ]; then
      if [ "${SPAWNED_MODE}" = true ]; then
        for d in "${dirs[@]}"; do ${WM_SPAWN} "${TERMINAL} -D '${d//\'/\'\\\'\'}'"; done
      else
        echo "${dirs[0]}" >"/tmp/fzf_cd_${PPID}"
      fi
    fi
    return 0
  fi

  declare -a batch_files
  local paths_to_copy=""

  if [[ "$act_key" == "ctrl-d" ]]; then
    save_action_history "[Open Dir]" "ctrl-d" "${act_results[@]}"
  fi

  for result in "${act_results[@]}"; do
    local raw_path=$(get_abs_path "$result")

    if [ "$act_key" = "ctrl-d" ]; then
      [ ! -d "$raw_path" ] && raw_path=$(dirname "$raw_path")
      local path_file="${raw_path//\'/\'\\\'\'}"

      if [ "${SPAWNED_MODE}" = true ]; then
        ${WM_SPAWN} "${TERMINAL} -D '${path_file}'"
      else
        echo "$raw_path" >"/tmp/fzf_cd_${PPID}"
        return 0
      fi
      continue
    fi

    if [ ! -d "$raw_path" ]; then
      batch_files+=("$raw_path")
      paths_to_copy+="$raw_path"$'\n'
    fi
  done

  if [ ${#batch_files[@]} -gt 0 ]; then
    case "$act_key" in
    "ctrl-y")
      save_action_history "[Copy]" "ctrl-y" "${batch_files[@]}"
      if [ ${#batch_files[@]} -eq 1 ]; then
        local first_file="${batch_files[0]}"
        local file_size=$(stat -c%s "$first_file" 2>/dev/null || stat -f%z "$first_file")
        if [ "$file_size" -lt 10485760 ]; then
          wl-copy <"$first_file"
          notify-send "Copied value" "$(basename "$first_file")"
        else
          notify-send "Error" "File too large (>10MB)"
        fi
      else
        local uri_list=""
        for file in "${batch_files[@]}"; do
          uri_list+="file://${file}\r\n"
        done
        echo -e -n "$uri_list" | wl-copy -t text/uri-list
        notify-send "Copied multiple" "${#batch_files[@]} files ready to paste"
      fi
      ;;
    "ctrl-a")
      save_action_history "[Copy Path]" "ctrl-a" "${batch_files[@]}"
      echo -n "$paths_to_copy" | wl-copy
      notify-send "Copied paths" "${#batch_files[@]} file(s)"
      ;;
    "ctrl-v")
      save_action_history "[Move]" "ctrl-v" "${batch_files[@]}"
      mv -vn "${batch_files[@]}" .
      notify-send "Moved" "${#batch_files[@]} file(s)"
      ;;
    "ctrl-x")
      save_action_history "[Rip]" "ctrl-x" "${batch_files[@]}"
      rip "${batch_files[@]}"
      notify-send "Ripped" "${#batch_files[@]} file(s)"
      ;;
    "ctrl-f")
      save_action_history "[PureRef]" "ctrl-f" "${batch_files[@]}"
      printf -v joined_files "%q " "${batch_files[@]}"
      if [ "${SPAWNED_MODE}" = true ]; then
        $WM_SPAWN "PureRef $joined_files"
      else
        PureRef -S AutoArrange=true "${batch_files[@]}" &
      fi
      notify-send "PureRef" "Opened ${#batch_files[@]} files"
      ;;
    "ctrl-e")
      save_action_history "[Collage]" "ctrl-e" "${batch_files[@]}"
      declare -a images_to_stitch
      for f in "${batch_files[@]}"; do
        case "${f##*.}" in
        [Pp][Nn][Gg] | [Jj][Pp][Gg] | [Jj][Pp][Ee][Gg] | [Ww][Ee][Bb][Pp])
          images_to_stitch+=("$f")
          ;;
        esac
      done

      local COUNT=${#images_to_stitch[@]}

      if [ "$COUNT" -eq 2 ]; then
        local OUT=$(mktemp /tmp/fzf_side_by_side_XXXX.png)
        magick "${images_to_stitch[@]}" \
          -gravity center \
          -background "#282828" \
          +smush 20 \
          -bordercolor "#282828" -border 20 \
          "$OUT"
        wl-copy -t image/png <"$OUT"
        notify-send "Side-by-Side" "Stitched horizontally and copied!"

      elif [ "$COUNT" -gt 2 ]; then
        local OUT=$(mktemp /tmp/fzf_moodboard_XXXX.png)
        montage "${images_to_stitch[@]}" -auto-orient -geometry 800x800\>+10+10 -background gray -tile 3x "$OUT"
        wl-copy -t image/png <"$OUT"
        notify-send "Moodboard" "Grid of $COUNT images copied!"

      else
        notify-send "Error" "Select 2 or more images"
      fi
      ;;
    esac
  fi
}

if [[ "$key" == "ctrl-z" ]]; then
  if [[ ! -f "$HISTORY_FILE" ]]; then
    notify-send "History" "History is empty."
    exit 0
  fi

  hist_selection=$(
    awk -F ' ::: ' '{
    raw_paths=$3
    display_paths=$3
    gsub(/\|/, ", ", display_paths)
    printf "\033[33m%-15s\033[0m ::: %s ::: %s ::: %s\n", $1, $2, raw_paths, display_paths
  }' "$HISTORY_FILE" | fzf --ansi --delimiter=' ::: ' --with-nth=1,4 \
      --prompt="History> " \
      --bind="$HIST_IPC_BIND"
  )

  [[ -z "$hist_selection" ]] && exit 0

  while IFS= read -r line; do
    entry_key=$(echo "$line" | awk -F ' ::: ' '{print $2}')
    entry_paths=$(echo "$line" | awk -F ' ::: ' '{print $3}')

    IFS='|' read -r -a entry_results <<<"$entry_paths"

    execute_action "$entry_key" "${entry_results[@]}"
  done <<<"$hist_selection"

  exit 0
fi

execute_action "$key" "${results[@]}"
