function mkproj --description "Create a new content/edu project with Rust-like structure"
    set -l categories art edu

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

    mkdir -p $target_dir/{src,assets,docs,dist}

    # Генерируем красивый README
    set -l readme "# $name

## 📌 Назначение папок
- **src/**: Мои исходники (тексты конспектов, .kra файлы, наброски).
- **assets/**: Внешние ресурсы (PDF книг, референсы, паки кистей).
- **docs/**: Справка, ссылки, план работы, чеклисты.
- **dist/**: Готовый экспорт (PNG, PDF-конспекты, финальные отчеты).

---
Создано: "(date "+%Y-%m-%d %H:%M")"
"
    echo "$readme" >$target_dir/README.md

    # Добавляем пустой файл индекса в src, чтобы папка не была совсем пустой
    if test $cat = edu
        touch $target_dir/src/notes.md
    else
        touch $target_dir/src/.gitkeep
    end

    echo "✅ Проект '$name' готов в ~/$cat/"
    cd $target_dir
end
