if [ "$#" -ne 2 ]; then
  echo "old_name new_name"
  exit 1
fi

OLD_NAME="$1"
NEW_NAME="$2"

GREEN=$(printf '\033[1;32m')
RESET=$(printf '\033[0m')

FILES_TO_CNAGE=$(grep -rl "\b$OLD_NAME\b" 2>/dev/null)

if [[ -z "$FILES_TO_CNAGE" ]]; then
  echo "$OLD_NAME dont found"
  exit 1
fi

echo "$FILES_TO_CNAGE" | xargs sed "s/\b$OLD_NAME\b/$GREEN$NEW_NAME$RESET/g" | less -R

prompt="try? (y/n) "

read -rep "$prompt" query

if [[ "$query" == "y" ]]; then
  git add . && git commit -m "replace: $1 to $2" && printf "\e[31mgit bak commit create!!!\e[0m\n" || printf "\e[31mgit \033[35mDONT\033[0m \e[31mbak commit create!!!\e[0m\n"
  echo "$FILES_TO_CNAGE" | xargs sed -i "s/\b$1\b/$2/g"
fi
