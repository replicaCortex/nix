#!/usr/bin/env fish

# ============================================
# Таймер и будильник для Fish Shell
# ============================================

# --- Функция уведомления ---
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

# ============================================
# Команда: timer — обратный отсчёт
# ============================================
function timer -d "Таймер обратного отсчёта. Использование: timer 5m / timer 1h30m / timer 90s / timer 90"
    if test (count $argv) -lt 1
        echo "Использование:"
        echo "  timer <длительность> [сообщение]"
        echo ""
        echo "Форматы длительности:"
        echo "  timer 30        # 30 секунд"
        echo "  timer 30s       # 30 секунд"
        echo "  timer 5m        # 5 минут"
        echo "  timer 1h30m     # 1 час 30 минут"
        echo "  timer 2h15m30s  # 2 часа 15 минут 30 секунд"
        echo ""
        echo "Примеры:"
        echo "  timer 25m Помидорка закончилась!"
        echo "  timer 3m Чай заварился"
        return 1
    end

    set -l duration_str $argv[1]
    set -l total_seconds (__parse_duration $duration_str)

    if test $total_seconds -le 0
        echo "❌ Ошибка: неверный формат времени '$duration_str'"
        echo "   Примеры: 30s, 5m, 1h30m, 90"
        return 1
    end

    # Сообщение
    set -l message "Время вышло!"
    if test (count $argv) -ge 2
        set message (string join " " $argv[2..-1])
    end

    set -l total_display (__format_time $total_seconds)
    echo "⏱  Таймер установлен на $total_display ($total_seconds сек.)"
    echo "   Сообщение: \"$message\""
    echo "   Нажмите Ctrl+C для отмены"
    echo ""

    set -l remaining $total_seconds

    while test $remaining -gt 0
        set -l time_str (__format_time $remaining)
        set -l elapsed (math "$total_seconds - $remaining")
        set -l bar (__progress_bar $elapsed $total_seconds)

        # \r — возврат каретки, перезаписываем строку
        printf "\r   ⏳ Осталось: %s  %s " $time_str $bar

        sleep 1
        set remaining (math "$remaining - 1")
    end

    # Финальная строка
    set -l bar_done (__progress_bar $total_seconds $total_seconds)
    printf "\r   ✅ Готово!    %s  %s \n" "00:00:00" $bar_done

    __notify_alarm $message
end

# ============================================
# Команда: stopwatch — секундомер
# ============================================
function stopwatch -d "Секундомер. Нажмите Enter для круга, Ctrl+C для остановки."
    echo "⏱  Секундомер запущен!"
    echo "   Нажмите Enter для отметки круга"
    echo "   Нажмите Ctrl+C для остановки"
    echo ""

    set -l start_time (date +%s)
    set -l lap_count 0
    set -l last_lap_time $start_time

    while true
        set -l now (date +%s)
        set -l elapsed (math "$now - $start_time")
        set -l display (__format_time $elapsed)

        printf "\r   ⏱  %s " $display

        # Проверяем, нажат ли Enter (неблокирующее чтение)
        if read -n 1 -t 1 -l key 2>/dev/null
            if test -z "$key" -o "$key" = ""
                set lap_count (math "$lap_count + 1")
                set now (date +%s)
                set elapsed (math "$now - $start_time")
                set -l lap_time (math "$now - $last_lap_time")
                set last_lap_time $now

                set -l total_display (__format_time $elapsed)
                set -l lap_display (__format_time $lap_time)
                printf "\n   🏁 Круг %2d: %s (общее: %s)\n" $lap_count $lap_display $total_display
            end
        end
    end
end
