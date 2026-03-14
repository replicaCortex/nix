#!/usr/bin/env bash

TITLE=$(niri msg -j focused-window | jq -r '.title')

if [ -z "$TITLE" ]; then
  exit 1
fi

# Извлекаем путь из title
PATH_PART=""

# Проверяем формат Nvim: "filename (~/path) - Nvim"
NVIM_PATH=$(echo "$TITLE" | grep -oP '\(\K[^)]+(?=\)\s*-\s*Nvim)')

if [ -n "$NVIM_PATH" ]; then
  PATH_PART="$NVIM_PATH"
else
  # Пробуем просто путь в скобках
  PAREN_PATH=$(echo "$TITLE" | grep -oP '\(\K[^)]+(?=\))')
  if [ -n "$PAREN_PATH" ]; then
    PATH_PART="$PAREN_PATH"
  else
    # Обычный формат: ищем путь в строке
    PATH_PART=$(echo "$TITLE" | grep -oE '(~[^ ]*|/[^ ]*|\./[^ ]*)' | tail -1)
  fi
fi

if [ -n "$PATH_PART" ]; then
  FULL_PATH="${PATH_PART/#\~/$HOME}"

  # Если путь существует напрямую, возвращаем его
  if [ -d "$FULL_PATH" ]; then
    echo "$FULL_PATH"
    exit 0
  fi

  # Разбиваем путь на компоненты
  IFS='/' read -ra PATH_COMPONENTS <<<"${FULL_PATH/#$HOME\//}"

  # Последняя директория - главный критерий
  LAST_DIR="${PATH_COMPONENTS[-1]}"

  if [ -z "$LAST_DIR" ]; then
    echo "$HOME"
    exit 0
  fi

  # Ищем все директории с таким именем
  mapfile -t CANDIDATES < <(fd -t d -H -a "^${LAST_DIR}$" "$HOME" 2>/dev/null)

  # Если ничего не нашли, возвращаем HOME
  if [ ${#CANDIDATES[@]} -eq 0 ]; then
    echo "$HOME"
    exit 0
  fi

  # Если нашли только одну - возвращаем её
  if [ ${#CANDIDATES[@]} -eq 1 ]; then
    echo "${CANDIDATES[0]}"
    exit 0
  fi

  # Функция для подсчёта совпадений
  score_path() {
    local candidate="$1"
    local score=0

    local rel_path="${candidate/#$HOME\//}"
    IFS='/' read -ra CAND_COMPONENTS <<<"$rel_path"

    local min_len=${#PATH_COMPONENTS[@]}
    [ ${#CAND_COMPONENTS[@]} -lt "$min_len" ] && min_len=${#CAND_COMPONENTS[@]}

    for ((i = 0; i < min_len - 1; i++)); do
      local orig="${PATH_COMPONENTS[i]}"
      local cand="${CAND_COMPONENTS[i]}"

      if [ "$orig" = "$cand" ]; then
        score=$((score + 10))
      elif [ "${orig:0:1}" = "${cand:0:1}" ]; then
        score=$((score + 5))
      fi
    done

    echo "$score"
  }

  BEST_SCORE=-1
  BEST_PATH=""

  for candidate in "${CANDIDATES[@]}"; do
    score=$(score_path "$candidate")
    if [ "$score" -gt "$BEST_SCORE" ]; then
      BEST_SCORE=$score
      BEST_PATH="$candidate"
    fi
  done

  if [ -n "$BEST_PATH" ]; then
    echo "$BEST_PATH"
  else
    echo "${CANDIDATES[0]}"
  fi
else
  echo "$HOME"
fi
