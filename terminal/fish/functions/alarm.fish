function __notify_alarm
    set -l message $argv[1]

    echo ""
    echo "============================================"
    echo "  ⏰ $message"
    echo "============================================"
    echo ""

    # Звуковой сигнал (несколько бипов)
    for i in (seq 1 5)
        printf '\a'
        sleep 0.3
    end

    # Попытка использовать системные уведомления
    if command -q notify-send
        # Linux (libnotify)
        notify-send "⏰ Таймер" "$message"
    end
end

# --- Парсинг времени для таймера (например: 1h30m45s, 10m, 90s, 5) ---
function __parse_duration
    set -l input $argv[1]
    set -l total_seconds 0

    # Если просто число — считаем секундами
    if string match -qr '^[0-9]+$' $input
        set total_seconds $input
        echo $total_seconds
        return 0
    end

    # Парсим часы
    set -l hours (string match -r '([0-9]+)h' $input)
    if test (count $hours) -ge 2
        set total_seconds (math "$total_seconds + $hours[2] * 3600")
    end

    # Парсим минуты
    set -l minutes (string match -r '([0-9]+)m' $input)
    if test (count $minutes) -ge 2
        set total_seconds (math "$total_seconds + $minutes[2] * 60")
    end

    # Парсим секунды
    set -l seconds (string match -r '([0-9]+)s' $input)
    if test (count $seconds) -ge 2
        set total_seconds (math "$total_seconds + $seconds[2]")
    end

    if test $total_seconds -eq 0
        echo -1
        return 1
    end

    echo $total_seconds
    return 0
end

# --- Форматирование секунд в HH:MM:SS ---
function __format_time
    set -l total $argv[1]
    set -l h (math "floor($total / 3600)")
    set -l m (math "floor(($total % 3600) / 60)")
    set -l s (math "$total % 60")
    printf "%02d:%02d:%02d" $h $m $s
end

# --- Прогресс-бар ---
function __progress_bar
    set -l current $argv[1]
    set -l total $argv[2]
    set -l width 30

    set -l filled (math "round($current / $total * $width)")
    set -l empty (math "$width - $filled")

    set -l bar ""
    for i in (seq 1 $filled)
        set bar "$bar█"
    end
    for i in (seq 1 $empty)
        set bar "$bar░"
    end

    set -l percent (math "round($current / $total * 100)")
    echo "$bar $percent%"
end

function alarm -d "Будильник. Использование: alarm 14:30 [сообщение]"
    if test (count $argv) -lt 1
        echo "Использование:"
        echo "  alarm <время> [сообщение]"
        echo ""
        echo "Форматы времени:"
        echo "  alarm 14:30        # Будильник на 14:30"
        echo "  alarm 9:00         # Будильник на 09:00"
        echo "  alarm 23:15:30     # Будильник на 23:15:30"
        echo ""
        echo "Примеры:"
        echo "  alarm 07:00 Пора вставать!"
        echo "  alarm 13:00 Обед"
        echo "  alarm 18:30 Конец рабочего дня"
        return 1
    end

    set -l time_str $argv[1]

    # Парсим время
    set -l parts (string split ":" $time_str)
    set -l target_h 0
    set -l target_m 0
    set -l target_s 0

    if test (count $parts) -ge 2
        set target_h $parts[1]
        set target_m $parts[2]
    else
        echo "❌ Ошибка: неверный формат времени '$time_str'"
        echo "   Используйте формат ЧЧ:ММ или ЧЧ:ММ:СС"
        return 1
    end

    if test (count $parts) -ge 3
        set target_s $parts[3]
    end

    # Валидация
    if test $target_h -lt 0 -o $target_h -gt 23 2>/dev/null
        echo "❌ Ошибка: часы должны быть от 0 до 23"
        return 1
    end
    if test $target_m -lt 0 -o $target_m -gt 59 2>/dev/null
        echo "❌ Ошибка: минуты должны быть от 0 до 59"
        return 1
    end
    if test $target_s -lt 0 -o $target_s -gt 59 2>/dev/null
        echo "❌ Ошибка: секунды должны быть от 0 до 59"
        return 1
    end

    # Сообщение
    set -l message "Будильник!"
    if test (count $argv) -ge 2
        set message (string join " " $argv[2..-1])
    end

    # Вычисляем сколько секунд до целевого времени
    set -l now_h (date +%H | string replace -r '^0' '')
    set -l now_m (date +%M | string replace -r '^0' '')
    set -l now_s (date +%S | string replace -r '^0' '')

    # Убираем ведущие нули для math
    set target_h (string replace -r '^0+(\d)' '$1' $target_h)
    set target_m (string replace -r '^0+(\d)' '$1' $target_m)
    set target_s (string replace -r '^0+(\d)' '$1' $target_s)

    # Обработка пустых строк после замены
    test -z "$now_h"; and set now_h 0
    test -z "$now_m"; and set now_m 0
    test -z "$now_s"; and set now_s 0
    test -z "$target_h"; and set target_h 0
    test -z "$target_m"; and set target_m 0
    test -z "$target_s"; and set target_s 0

    set -l now_total (math "$now_h * 3600 + $now_m * 60 + $now_s")
    set -l target_total (math "$target_h * 3600 + $target_m * 60 + $target_s")

    set -l diff (math "$target_total - $now_total")

    # Если время уже прошло — ставим на следующий день
    if test $diff -le 0
        set diff (math "$diff + 86400")
        echo "⚠  Время $time_str уже прошло сегодня. Будильник установлен на завтра."
    end

    set -l target_display (printf "%02d:%02d:%02d" $target_h $target_m $target_s)
    set -l wait_display (__format_time $diff)

    echo "🔔 Будильник установлен на $target_display"
    echo "   Ожидание: $wait_display"
    echo "   Сообщение: \"$message\""
    echo "   Нажмите Ctrl+C для отмены"
    echo ""

    set -l total_wait $diff

    while test $diff -gt 0
        set -l time_left (__format_time $diff)
        set -l elapsed (math "$total_wait - $diff")
        set -l bar (__progress_bar $elapsed $total_wait)
        set -l current_time (date +%H:%M:%S)

        printf "\r   🕐 Сейчас: %s | Осталось: %s  %s " $current_time $time_left $bar

        sleep 1
        set diff (math "$diff - 1")
    end

    set -l bar_done (__progress_bar $total_wait $total_wait)
    set -l final_time (date +%H:%M:%S)
    printf "\r   ✅ %s — Будильник сработал!          %s \n" $final_time $bar_done

    __notify_alarm $message
end
