# =========================================================
# QUTEBROWSER CONFIG (Tabless / Minimalist / Vim-way)
# =========================================================
import os

# Обязательная строчка, чтобы конфиг не перезаписывался из GUI
config.load_autoconfig(False)

# =========================================================
# 1. ОБЩИЕ НАСТРОЙКИ UI И ПОВЕДЕНИЯ
# =========================================================

# Включаем принудительный Dark Mode для всех сайтов
c.colors.webpage.darkmode.enabled = True

# Максимальный минимализм: скрываем скроллбар и панель вкладок
c.tabs.show = "never"
c.scrolling.bar = "never"

# =========================================================
# 2. УПРАВЛЕНИЕ ОКНАМИ (Tabless Workflow для WM)
# =========================================================

# Внешние программы и клик колесиком открывают ссылки в новом окне (тайле)
c.new_instance_open_target = "window"
c.tabs.tabs_are_windows = True

# =========================================================
# 3. ВНЕШНИЙ РЕДАКТОР (NeoVim через Foot)
# =========================================================

smart_float = os.environ.get(
    "SMART_FLOAT",
    os.path.expanduser("~/sys/nix/terminal/scripts/smart_float.sh"),
)

nvim_call_back = os.environ.get(
    "NVIM_CALL_BACK",
    os.path.expanduser("~/sys/nix/terminal/scripts/nvim_focus_callback.sh"),
)

c.editor.command = [
    nvim_call_back,
    "{file}",
    "-c",
    "normal {line}G{column0}l",
    # "-c",
    # "startinsert",
]

# =========================================================
# 4. НАСТРОЙКА ХИНТОВ (Клавиша 'f')
# =========================================================

# Используем только буквы домашнего ряда
c.hints.chars = "asdfghjkl"

# Дополнительный селектор 'text' (вызов через 'xt') для абзацев и кода в LLM-чатах
c.hints.selectors["text"] = ["p", "pre", "code", "li"]

# =========================================================
# 5. ГОРЯЧИЕ КЛАВИШИ И СКРИПТЫ
# =========================================================

# --- Окна и история ---
config.bind("F", "hint all window")  # 'F' открывает ссылку в новом тайле
# Нажимаем gE (или пУ на русской):
config.bind("E", "hint inputs --first ;; cmd-later 50 edit-text")
# При нажатии Enter в режиме ввода: отправить Enter на сайт и выйти в Normal mode
config.bind("<Return>", "fake-key <Return> ;; mode-leave", mode="insert")
config.bind(
    "O", "set-cmd-text -s :open -w"
)  # 'O' предлагает ввести URL для нового тайла
config.bind("P", "open -w -- {clipboard}")  # 'P' открывает буфер обмена в новом тайле
config.bind("<Ctrl-o>", "back")  # Назад по истории
config.bind("<Ctrl-i>", "forward")  # Вперед по истории

# --- Быстрая прокрутка (на пол-экрана) ---
config.bind("<Ctrl-d>", "scroll-page 0 0.5")  # Вниз
config.bind("<Ctrl-u>", "scroll-page 0 -0.5")  # Вверх
config.bind(
    "yi", "hint images spawn bash -c 'curl -sL {hint-url} | wl-copy -t image/png'"
)
config.bind(
    "ya",
    "jseval --quiet navigator.clipboard.writeText(document.documentElement.innerText)",
)

# =========================================================
# 5.1 ИНТЕГРАЦИЯ С WCRAWL (Markdown Crawler)
# =========================================================

# 'cm' (Copy Markdown) — Скачать текущую страницу и скопировать в буфер
config.bind(
    "cm",
    'spawn bash -c \'cd ~/dev/crawler/ && uv run crawler.py {url} -s && notify-send "wcrawl" "Страница скопирована!"\'',
)

# 'cM' (Copy Markdown Hint) — Выбрать ссылку хинтом и отправить её в wcrawl
config.bind("cM", "hint links spawn wcrawl {hint-url} -s")

# Дополнительно: уведомление в статусбаре qutebrowser (опционально)
# Чтобы видеть, что процесс пошел, можно обернуть в bash и вывести сообщение
config.bind(
    "cx",
    "spawn --userscript bash -c 'qute-messenger info \"Crawling {url}...\" && wcrawl {url} -s'",
)

# --- Умный прыжок в начало/конец чата (игнорирует фокус) ---
js_to_bottom = """
jseval --quiet
var scrollers = Array.from(document.querySelectorAll('*')).filter(e => e.scrollHeight > e.clientHeight && (getComputedStyle(e).overflowY === 'auto' || getComputedStyle(e).overflowY === 'scroll'));
if(scrollers.length > 0) { scrollers[scrollers.length - 1].scrollTop = scrollers[scrollers.length - 1].scrollHeight; } 
else { window.scrollTo(0, document.body.scrollHeight); }
"""

js_to_top = """
jseval --quiet
var scrollers = Array.from(document.querySelectorAll('*')).filter(e => e.scrollHeight > e.clientHeight && (getComputedStyle(e).overflowY === 'auto' || getComputedStyle(e).overflowY === 'scroll'));
if(scrollers.length > 0) { scrollers[scrollers.length - 1].scrollTop = 0; } 
else { window.scrollTo(0, 0); }
"""

config.bind("G", js_to_bottom.replace("\n", " "))
config.bind("gg", js_to_top.replace("\n", " "))

# =========================================================
# 6. РУССКАЯ РАСКЛАДКА
# =========================================================

ru_key_mapping = {
    "й": "q",
    "ц": "w",
    "у": "e",
    "к": "r",
    "е": "t",
    "н": "y",
    "г": "u",
    "ш": "i",
    "щ": "o",
    "з": "p",
    "х": "[",
    "ъ": "]",
    "ф": "a",
    "ы": "s",
    "в": "d",
    "а": "f",
    "п": "g",
    "р": "h",
    "о": "j",
    "л": "k",
    "д": "l",
    "ж": ";",
    "э": "'",
    "я": "z",
    "ч": "x",
    "с": "c",
    "м": "v",
    "и": "b",
    "т": "n",
    "ь": "m",
    "б": ",",
    "ю": ".",
    ".": "/",
    "Й": "Q",
    "Ц": "W",
    "У": "E",
    "К": "R",
    "Е": "T",
    "Н": "Y",
    "Г": "U",
    "Ш": "I",
    "Щ": "O",
    "З": "P",
    "Х": "{",
    "Ъ": "}",
    "Ф": "A",
    "Ы": "S",
    "В": "D",
    "А": "F",
    "П": "G",
    "Р": "H",
    "О": "J",
    "Л": "K",
    "Д": "L",
    "Ж": ":",
    "Э": '"',
    "Я": "Z",
    "Ч": "X",
    "С": "C",
    "М": "V",
    "И": "B",
    "Т": "N",
    "Ь": "M",
    "Б": "<",
    "Ю": ">",
    ",": "?",
}
c.bindings.key_mappings.update(ru_key_mapping)

# =========================================================
# 7. ТЕМА GRUVBOX DARK
# =========================================================

bg0 = "#282828"
bg1 = "#3c3836"
bg2 = "#504945"
fg0 = "#fbf1c7"
fg1 = "#ebdbb2"
fg2 = "#d5c4a1"
fg4 = "#a89984"
red = "#cc241d"
green = "#98971a"
yellow = "#d79921"
blue = "#458588"
purple = "#b16286"
aqua = "#689d6a"
orange = "#d65d0e"

c.colors.webpage.bg = bg0
c.colors.webpage.preferred_color_scheme = "dark"
c.url.default_page = "about:blank"
c.url.start_pages = ["about:blank"]
c.colors.completion.fg = fg1
c.colors.completion.category.fg = yellow
c.colors.completion.category.bg = bg0
c.colors.completion.category.border.top = bg0
c.colors.completion.category.border.bottom = bg0
c.colors.completion.item.selected.fg = fg0
c.colors.completion.item.selected.bg = bg2
c.colors.completion.item.selected.border.top = bg2
c.colors.completion.item.selected.border.bottom = bg2
c.colors.completion.item.selected.match.fg = green
c.colors.completion.match.fg = orange
c.colors.completion.scrollbar.fg = fg2
c.colors.completion.scrollbar.bg = bg0

c.colors.statusbar.normal.fg = blue
c.colors.statusbar.normal.bg = bg0
c.colors.statusbar.insert.fg = bg0
c.colors.statusbar.insert.bg = purple
c.colors.statusbar.passthrough.fg = bg0
c.colors.statusbar.passthrough.bg = blue
c.colors.statusbar.command.fg = fg1
c.colors.statusbar.command.bg = bg1
c.colors.statusbar.command.private.fg = fg1
c.colors.statusbar.command.private.bg = bg1
c.colors.statusbar.caret.fg = bg0
c.colors.statusbar.caret.bg = blue
c.colors.statusbar.caret.selection.fg = bg0
c.colors.statusbar.caret.selection.bg = purple
c.colors.statusbar.progress.bg = fg2
c.colors.statusbar.url.fg = fg4
c.colors.statusbar.url.error.fg = red
c.colors.statusbar.url.hover.fg = aqua
c.colors.statusbar.url.success.http.fg = fg2
c.colors.statusbar.url.success.https.fg = green
c.colors.statusbar.url.warn.fg = yellow

c.colors.messages.error.fg = bg0
c.colors.messages.error.bg = red
c.colors.messages.error.border = red
c.colors.messages.warning.fg = bg0
c.colors.messages.warning.bg = yellow
c.colors.messages.warning.border = yellow
c.colors.messages.info.fg = fg2
c.colors.messages.info.bg = bg0
c.colors.messages.info.border = bg0

c.colors.hints.fg = bg0
c.colors.hints.bg = yellow
c.colors.hints.match.fg = fg0
c.hints.border = f"1px solid {bg0}"

c.colors.downloads.bar.bg = bg0
c.colors.downloads.start.fg = bg0
c.colors.downloads.start.bg = blue
c.colors.downloads.stop.fg = bg0
c.colors.downloads.stop.bg = green
c.colors.downloads.error.fg = red

c.colors.prompts.fg = fg2
c.colors.prompts.border = f"1px solid {bg1}"
c.colors.prompts.bg = bg0
c.colors.prompts.selected.bg = bg2

# =========================================================
# 8. ШРИФТЫ
# =========================================================

my_font = '"Ubuntu Mono Nerd Font"'

c.fonts.default_family = my_font
c.fonts.default_size = "11pt"

c.fonts.hints = f"bold 13pt {my_font}"
c.fonts.statusbar = f"11pt {my_font}"
c.fonts.completion.entry = f"11pt {my_font}"
c.fonts.completion.category = f"bold 11pt {my_font}"
c.fonts.prompts = f"11pt {my_font}"
c.fonts.messages.info = f"11pt {my_font}"
c.fonts.messages.warning = f"11pt {my_font}"
c.fonts.messages.error = f"11pt {my_font}"

c.fonts.web.family.fixed = my_font

c.zoom.default = "110%"

c.downloads.location.directory = "~/"
c.downloads.prevent_mixed_content = True
c.content.blocking.method = "both"

# ---

c.content.javascript.enabled = True
#
# config.set("content.javascript.enabled", True, "*://github.com/*")
# config.set("content.javascript.enabled", True, "*://arena.ai/*")
