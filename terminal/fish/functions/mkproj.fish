function mkproj --description "Create a universal project template with ready-to-edit files"
    set -l categories art edu dev

    if test (count $argv) -lt 2
        echo "Usage: mkproj <category> <name>"
        echo "Categories: $categories"
        return 1
    end

    set -l cat $argv[1]
    set -l name $argv[2]
    set -l target_dir ~/$cat/$name

    if test -d $target_dir
        echo "Error: Path $target_dir already exists!"
        return 1
    end

    mkdir -p $target_dir/{src,assets,dist}
    cd $target_dir

    echo "\
default:
	@just --list

run:
	@echo 'Add your run command here'

build:
	@echo 'Add your build command here'
" >justfile

    echo "\
# $name

Создано: "(date "+%Y-%m-%d %H:%M")"

## 📂 Структура
- \`src/\` — Исходный код или тексты
- \`assets/\` — Внешние ресурсы
- \`dist/\` — Результаты компиляции / сборки
" >README.md

    git init -q
    jj git init .
end
