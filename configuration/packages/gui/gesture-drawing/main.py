"""
Gesture Drawing Practice App (PyQt6) - Gruvbox Theme
Минималистичное приложение для практики рисования жестов

CLI:
    python main.py                          # Обычный запуск
    python main.py -p /path/to/images       # Путь к изображениям
    python main.py -t 60                    # 60 секунд на рисунок
    python main.py -t 45 -c 15              # 45 сек, 15 фото
    python main.py -p ./refs -t 30 -s       # Путь, 30 сек, автостарт
    python main.py -t 120 -c 5 -d 5 -s      # 2 мин, 5 фото, 5 сек подготовка
    python main.py -p ./refs -m -s          # Минималистичный режим с автостартом
"""

import argparse
import array
import math
import random
import sys
from pathlib import Path

from PyQt6.QtCore import Qt, QTimer
from PyQt6.QtGui import QColor, QFont, QPainter, QPixmap
from PyQt6.QtWidgets import (
    QApplication,
    QCheckBox,
    QFileDialog,
    QHBoxLayout,
    QLabel,
    QMainWindow,
    QMessageBox,
    QPushButton,
    QSizePolicy,
    QSpinBox,
    QVBoxLayout,
    QWidget,
)

try:
    import pygame

    pygame.mixer.init(frequency=44100, size=-16, channels=1)
    SOUND_AVAILABLE = True
except ImportError:
    SOUND_AVAILABLE = False


# =============================================================================
# Настройки по умолчанию
# =============================================================================
DEFAULT_TIME = 30
DEFAULT_DELAY = 3
DEFAULT_SOUND = True
DEFAULT_SHUFFLE = True

SESSION_COUNTS = {
    30: 20,
    60: 10,
    120: 5,
}


# =============================================================================
# Gruvbox Color Palette
# =============================================================================
class Gruvbox:
    BG_HARD = "#1d2021"
    BG = "#282828"
    BG_SOFT = "#32302f"
    BG1 = "#3c3836"
    BG2 = "#504945"
    BG3 = "#665c54"
    BG4 = "#7c6f64"

    FG = "#ebdbb2"
    FG0 = "#fbf1c7"
    FG1 = "#ebdbb2"
    FG2 = "#d5c4a1"
    FG3 = "#bdae93"
    FG4 = "#a89984"

    RED = "#fb4934"
    RED_DIM = "#cc241d"
    GREEN = "#b8bb26"
    GREEN_DIM = "#98971a"
    YELLOW = "#fabd2f"
    YELLOW_DIM = "#d79921"
    BLUE = "#83a598"
    BLUE_DIM = "#458588"
    PURPLE = "#d3869b"
    PURPLE_DIM = "#b16286"
    AQUA = "#8ec07c"
    AQUA_DIM = "#689d6a"
    ORANGE = "#fe8019"
    ORANGE_DIM = "#d65d0e"
    GRAY = "#928374"


# =============================================================================
# Sound Manager
# =============================================================================
class SoundManager:
    def __init__(self):
        self.enabled = SOUND_AVAILABLE

    def _beep(self, freq=440, dur=200, vol=0.5):
        if not self.enabled:
            return None
        sample_rate = 44100
        n = int(sample_rate * dur / 1000)
        buf = array.array("h", [0] * n)
        amp = int(32767 * vol)
        for i in range(n):
            t = i / sample_rate
            env = 1.0 if i <= n * 0.7 else (n - i) / (n * 0.3)
            buf[i] = int(amp * env * math.sin(2 * math.pi * freq * t))
        return pygame.mixer.Sound(buffer=buf)

    def play_start(self):
        if s := self._beep(880, 150, 0.3):
            s.play()

    def play_warning(self):
        if s := self._beep(660, 100, 0.3):
            s.play()

    def play_end(self):
        if s := self._beep(440, 200, 0.4):
            s.play()
            QTimer.singleShot(250, lambda: s.play())

    def play_tick(self):
        if s := self._beep(1000, 50, 0.2):
            s.play()

    def play_countdown(self):
        if s := self._beep(550, 100, 0.25):
            s.play()


# =============================================================================
# Image Viewer
# =============================================================================
class ImageViewer(QLabel):
    def __init__(self):
        super().__init__()
        self.setAlignment(Qt.AlignmentFlag.AlignCenter)
        self.setMinimumSize(200, 150)
        self.setSizePolicy(QSizePolicy.Policy.Expanding, QSizePolicy.Policy.Expanding)
        self.setFocusPolicy(Qt.FocusPolicy.NoFocus)
        self.original_pixmap = None
        self._show_placeholder()

    def _show_placeholder(self, text="📁 Загрузите изображения"):
        self.original_pixmap = None
        self.setText(text)
        self.setStyleSheet(f"""
            QLabel {{
                background-color: {Gruvbox.BG};
                border: 2px solid {Gruvbox.BG2};
                border-radius: 8px;
                color: {Gruvbox.FG4};
                font-size: 16px;
            }}
        """)

    def set_image(self, path):
        try:
            px = QPixmap(path)
            if px.isNull():
                return False
            self.original_pixmap = px
            self._update_scaled()
            self.setStyleSheet(f"""
                QLabel {{
                    background-color: {Gruvbox.BG_HARD};
                    border: none;
                    border-radius: 0px;
                }}
            """)
            return True
        except:
            return False

    def _update_scaled(self):
        if self.original_pixmap:
            scaled = self.original_pixmap.scaled(
                self.size(),
                Qt.AspectRatioMode.KeepAspectRatio,
                Qt.TransformationMode.SmoothTransformation,
            )
            self.setPixmap(scaled)

    def hide_image(self):
        self.clear()
        self.setStyleSheet(f"""
            QLabel {{
                background-color: {Gruvbox.BG_HARD};
                border: none;
            }}
        """)

    def show_image(self):
        if self.original_pixmap:
            self._update_scaled()

    def resizeEvent(self, e):
        super().resizeEvent(e)
        if self.original_pixmap and self.pixmap() and not self.pixmap().isNull():
            self._update_scaled()


# =============================================================================
# Countdown Overlay
# =============================================================================
class CountdownOverlay(QWidget):
    def __init__(self, parent=None):
        super().__init__(parent)
        self.count = 3
        self.setVisible(False)
        self.setAttribute(Qt.WidgetAttribute.WA_TransparentForMouseEvents)

    def start(self, count=3):
        self.count = count
        self.setVisible(True)
        self.update()

    def set_count(self, count):
        self.count = count
        self.update()

    def hide_overlay(self):
        self.setVisible(False)

    def paintEvent(self, e):
        if not self.isVisible():
            return
        painter = QPainter(self)
        painter.setRenderHint(QPainter.RenderHint.Antialiasing)
        painter.fillRect(self.rect(), QColor(29, 32, 33, 230))
        painter.setPen(QColor(Gruvbox.AQUA))
        font = QFont("monospace", 100, QFont.Weight.Bold)
        painter.setFont(font)
        painter.drawText(self.rect(), Qt.AlignmentFlag.AlignCenter, str(self.count))


# =============================================================================
# No Focus Widgets
# =============================================================================
class NFButton(QPushButton):
    def __init__(self, *a, **kw):
        super().__init__(*a, **kw)
        self.setFocusPolicy(Qt.FocusPolicy.NoFocus)


class NFSpinBox(QSpinBox):
    def __init__(self, *a, **kw):
        super().__init__(*a, **kw)
        self.setFocusPolicy(Qt.FocusPolicy.NoFocus)


class NFCheckBox(QCheckBox):
    def __init__(self, *a, **kw):
        super().__init__(*a, **kw)
        self.setFocusPolicy(Qt.FocusPolicy.NoFocus)


# =============================================================================
# Вспомогательные функции
# =============================================================================
def get_session_count(time_sec: int) -> int:
    if time_sec in SESSION_COUNTS:
        return SESSION_COUNTS[time_sec]
    if time_sec <= 30:
        return 20
    elif time_sec <= 60:
        return 10
    elif time_sec <= 120:
        return 5
    else:
        return 3


def load_images_from_path(path: Path) -> list:
    valid_ext = {".jpg", ".jpeg", ".png", ".gif", ".bmp", ".webp"}
    images = []
    if path.is_dir():
        for f in path.iterdir():
            if f.is_file() and f.suffix.lower() in valid_ext:
                images.append(str(f))
    return images


# =============================================================================
# Main Application
# =============================================================================
class GestureApp(QMainWindow):
    COMPACT = 500
    MOBILE = 380

    def __init__(self, cli_args=None):
        super().__init__()

        self.cli_args = cli_args or {}
        self.minimal_mode = self.cli_args.get("minimal", False)
        self.auto_close = self.minimal_mode  # Автозакрытие в минимальном режиме

        self.images = []
        self.session_images = []
        self.current_idx = 0

        self.sel_time = self.cli_args.get("time") or DEFAULT_TIME
        self.remain = self.sel_time
        self.per_session = self.cli_args.get("count") or get_session_count(
            self.sel_time
        )
        self.countdown_seconds = self.cli_args.get("delay") or DEFAULT_DELAY

        self.running = False
        self.paused = False
        self.done_count = 0
        self.mode = "desktop"

        self.countdown_active = False
        self.countdown_value = self.countdown_seconds
        self.countdown_timer = QTimer()
        self.countdown_timer.timeout.connect(self._countdown_tick)

        self.sound = SoundManager()

        self.timer = QTimer()
        self.timer.timeout.connect(self._tick)

        self._init_ui()

        if path := self.cli_args.get("path"):
            self._load_from_path(Path(path))

        if self.cli_args.get("start") and self.images:
            QTimer.singleShot(100, self._start_with_countdown)

    def _init_ui(self):
        self.setWindowTitle("🎨 Gesture Drawing")
        self.setMinimumSize(280, 350)
        self.resize(900, 650)
        self.setStyleSheet(self._styles())

        central = QWidget()
        central.setFocusPolicy(Qt.FocusPolicy.StrongFocus)
        self.setCentralWidget(central)

        layout = QVBoxLayout(central)
        layout.setContentsMargins(
            0 if self.minimal_mode else 8,
            0 if self.minimal_mode else 8,
            0 if self.minimal_mode else 8,
            0 if self.minimal_mode else 8,
        )
        layout.setSpacing(0 if self.minimal_mode else 6)

        if not self.minimal_mode:
            self._create_top_bar(layout)

        self._create_image_area(layout)

        # Оверлей с информацией (для минимального режима поверх изображения)
        if self.minimal_mode:
            self._create_minimal_overlay()
        else:
            self._create_bottom_bar(layout)

        self.setFocus()
        QTimer.singleShot(50, self._adapt)

    def _styles(self):
        return f"""
            QMainWindow, QWidget {{
                background-color: {Gruvbox.BG_HARD if self.minimal_mode else Gruvbox.BG};
                color: {Gruvbox.FG};
                font-family: 'Ubuntu mono', 'JetBrains Mono', 'Fira Code', 'Consolas', monospace;
            }}
            
            QPushButton {{
                background-color: {Gruvbox.BG1};
                color: {Gruvbox.FG};
                border: 1px solid {Gruvbox.BG3};
                padding: 6px 12px;
                border-radius: 4px;
                font-size: 13px;
                font-weight: bold;
            }}
            QPushButton:hover {{
                background-color: {Gruvbox.BG2};
                border-color: {Gruvbox.AQUA};
            }}
            QPushButton:pressed {{
                background-color: {Gruvbox.BG3};
            }}
            QPushButton:disabled {{
                background-color: {Gruvbox.BG1};
                color: {Gruvbox.BG4};
                border-color: {Gruvbox.BG2};
            }}
            
            QSpinBox {{
                background-color: {Gruvbox.BG1};
                color: {Gruvbox.FG};
                border: 1px solid {Gruvbox.BG3};
                border-radius: 4px;
                padding: 4px 8px;
                font-size: 12px;
                min-width: 50px;
            }}
            QSpinBox:hover {{
                border-color: {Gruvbox.AQUA};
            }}
            QSpinBox:focus {{
                border-color: {Gruvbox.YELLOW};
            }}
            QSpinBox::up-button, QSpinBox::down-button {{
                background-color: {Gruvbox.BG2};
                border: none;
                width: 16px;
            }}
            QSpinBox::up-button:hover, QSpinBox::down-button:hover {{
                background-color: {Gruvbox.BG3};
            }}
            QSpinBox::up-arrow {{
                border-left: 4px solid transparent;
                border-right: 4px solid transparent;
                border-bottom: 5px solid {Gruvbox.FG4};
            }}
            QSpinBox::down-arrow {{
                border-left: 4px solid transparent;
                border-right: 4px solid transparent;
                border-top: 5px solid {Gruvbox.FG4};
            }}
            
            QCheckBox {{
                font-size: 13px;
                spacing: 6px;
            }}
            QCheckBox::indicator {{
                width: 16px;
                height: 16px;
                border-radius: 3px;
                border: 1px solid {Gruvbox.BG3};
                background-color: {Gruvbox.BG1};
            }}
            QCheckBox::indicator:hover {{
                border-color: {Gruvbox.AQUA};
            }}
            QCheckBox::indicator:checked {{
                background-color: {Gruvbox.AQUA_DIM};
                border-color: {Gruvbox.AQUA};
            }}
            
            QMessageBox {{
                background-color: {Gruvbox.BG};
            }}
            QMessageBox QLabel {{
                color: {Gruvbox.FG};
            }}
            QMessageBox QPushButton {{
                min-width: 80px;
            }}
        """

    def _create_top_bar(self, parent_layout):
        bar = QWidget()
        bar.setStyleSheet(f"background-color: {Gruvbox.BG_SOFT}; border-radius: 6px;")
        bar.setFixedHeight(44)
        lay = QHBoxLayout(bar)
        lay.setContentsMargins(8, 4, 8, 4)
        lay.setSpacing(6)

        self.btn_folder = NFButton("📁")
        self.btn_folder.setToolTip("Открыть папку")
        self.btn_folder.setFixedSize(32, 32)
        self.btn_folder.clicked.connect(self._load_folder)
        lay.addWidget(self.btn_folder)

        lay.addSpacing(8)

        lbl_time = QLabel("⏱")
        lbl_time.setStyleSheet(f"color: {Gruvbox.FG3};")
        lay.addWidget(lbl_time)

        self.spin_time = NFSpinBox()
        self.spin_time.setRange(5, 600)
        self.spin_time.setValue(self.sel_time)
        self.spin_time.setSuffix("с")
        self.spin_time.setToolTip("Время на жест (секунды)")
        self.spin_time.setFixedWidth(70)
        self.spin_time.valueChanged.connect(self._on_time_change)
        lay.addWidget(self.spin_time)

        lbl_count = QLabel("📷")
        lbl_count.setStyleSheet(f"color: {Gruvbox.FG3};")
        lay.addWidget(lbl_count)

        self.spin_count = NFSpinBox()
        self.spin_count.setRange(0, 999)
        self.spin_count.setValue(self.per_session)
        self.spin_count.setSpecialValueText("∞")
        self.spin_count.setToolTip("Количество жестов (0 = все)")
        self.spin_count.setFixedWidth(55)
        self.spin_count.valueChanged.connect(self._on_count_change)
        lay.addWidget(self.spin_count)

        self.spin_delay = NFSpinBox()
        self.spin_delay.setRange(1, 30)
        self.spin_delay.setValue(self.countdown_seconds)
        self.spin_delay.setToolTip("Секунды подготовки")
        self.spin_delay.setFixedWidth(45)
        self.spin_delay.setPrefix("⏱")
        self.spin_delay.valueChanged.connect(self._on_delay_change)
        lay.addWidget(self.spin_delay)

        self.chk_sound = NFCheckBox("🔊")
        self.chk_sound.setToolTip("Звук")
        self.chk_sound.setChecked(DEFAULT_SOUND)
        lay.addWidget(self.chk_sound)

        self.chk_shuffle = NFCheckBox("🔀")
        self.chk_shuffle.setToolTip("Перемешать")
        self.chk_shuffle.setChecked(DEFAULT_SHUFFLE)
        lay.addWidget(self.chk_shuffle)

        lay.addStretch()

        self.lbl_timer = QLabel("00:30")
        self.lbl_timer.setStyleSheet(f"""
            font-size: 26px;
            font-weight: bold;
                font-family: 'Ubuntu mono', 'JetBrains Mono', 'Fira Code', 'Consolas', monospace;
            color: {Gruvbox.GREEN};
            padding: 0 8px;
        """)
        lay.addWidget(self.lbl_timer)

        lay.addStretch()

        self.lbl_counter = QLabel("0/0")
        self.lbl_counter.setStyleSheet(
            f"font-size: 14px; font-weight: bold; color: {Gruvbox.BLUE};"
        )
        lay.addWidget(self.lbl_counter)

        parent_layout.addWidget(bar)
        self._update_timer_display()

    def _create_image_area(self, parent_layout):
        self.image_container = QWidget()
        self.image_container.setSizePolicy(
            QSizePolicy.Policy.Expanding, QSizePolicy.Policy.Expanding
        )
        container_layout = QVBoxLayout(self.image_container)
        container_layout.setContentsMargins(0, 0, 0, 0)

        self.viewer = ImageViewer()
        container_layout.addWidget(self.viewer)

        self.countdown_overlay = CountdownOverlay(self.image_container)

        parent_layout.addWidget(self.image_container, stretch=1)

    def _create_minimal_overlay(self):
        """Создание оверлея для минимального режима"""
        self.minimal_overlay = QWidget(self.image_container)
        self.minimal_overlay.setStyleSheet("background-color: transparent;")
        self.minimal_overlay.setAttribute(
            Qt.WidgetAttribute.WA_TransparentForMouseEvents
        )

        layout = QVBoxLayout(self.minimal_overlay)
        layout.setContentsMargins(10, 10, 10, 10)

        # Верхняя панель с таймером и счётчиком
        top_bar = QWidget()
        top_bar.setStyleSheet(f"""
            # background-color: rgba(29, 32, 33, 200);
            # border-radius: 8px;
        """)
        top_bar.setFixedHeight(50)
        top_layout = QHBoxLayout(top_bar)
        top_layout.setContentsMargins(15, 5, 15, 5)

        # Счётчик
        self.lbl_counter = QLabel("0/0")
        self.lbl_counter.setStyleSheet(f"""
            font-size: 20px;
            font-weight: bold;
            color: {Gruvbox.BLUE};
            background: transparent;
        """)
        top_layout.addWidget(self.lbl_counter)

        top_layout.addStretch()

        # Таймер
        self.lbl_timer = QLabel("00:30")
        self.lbl_timer.setStyleSheet(f"""
            font-size: 28px;
            font-weight: bold;
                font-family: 'Ubuntu mono', 'JetBrains Mono', 'Fira Code', 'Consolas', monospace;
            color: {Gruvbox.GREEN};
            background: transparent;
        """)
        top_layout.addWidget(self.lbl_timer)

        layout.addWidget(top_bar)
        layout.addStretch()

        # Подсказка внизу (пауза)
        self.lbl_hint = QLabel("Space: пауза | Esc: выход")
        self.lbl_hint.setStyleSheet(f"""
            font-size: 12px;
            color: {Gruvbox.FG4};
            background-color: rgba(29, 32, 33, 150);
            padding: 5px 10px;
            border-radius: 4px;
        """)
        self.lbl_hint.setAlignment(Qt.AlignmentFlag.AlignCenter)
        layout.addWidget(self.lbl_hint, alignment=Qt.AlignmentFlag.AlignCenter)

        self._update_timer_display()

        # Для минимального режима создаём фиктивные виджеты
        self.chk_sound = type(
            "obj", (object,), {"isChecked": lambda self: DEFAULT_SOUND}
        )()
        self.chk_shuffle = type(
            "obj", (object,), {"isChecked": lambda self: DEFAULT_SHUFFLE}
        )()

    def _create_bottom_bar(self, parent_layout):
        bar = QWidget()
        bar.setStyleSheet(f"background-color: {Gruvbox.BG_SOFT}; border-radius: 6px;")
        bar.setFixedHeight(50)
        lay = QHBoxLayout(bar)
        lay.setContentsMargins(10, 6, 10, 6)
        lay.setSpacing(8)

        self.btn_prev = NFButton("⏮")
        self.btn_prev.setToolTip("Предыдущее (←)")
        self.btn_prev.setEnabled(False)
        self.btn_prev.clicked.connect(self._prev)
        self.btn_prev.setStyleSheet(f"""
            QPushButton {{
                background-color: {Gruvbox.BG2};
                padding: 8px 14px;
            }}
            QPushButton:hover {{
                background-color: {Gruvbox.BG3};
                border-color: {Gruvbox.PURPLE};
            }}
        """)
        lay.addWidget(self.btn_prev)

        lay.addStretch()

        self.btn_start = NFButton("▶")
        self.btn_start.setToolTip("Space = старт/пауза | Shift+Space = с подготовкой")
        self._style_start_button(running=False)
        self.btn_start.clicked.connect(self._on_start_click)
        lay.addWidget(self.btn_start)

        self.btn_reset = NFButton("🔄")
        self.btn_reset.setToolTip("Сброс (R) | Shift+R = с подготовкой")
        self.btn_reset.setFixedSize(36, 36)
        self.btn_reset.clicked.connect(self._on_reset_click)
        self.btn_reset.setStyleSheet(f"""
            QPushButton {{
                background-color: {Gruvbox.BG3};
            }}
            QPushButton:hover {{
                background-color: {Gruvbox.BG4};
                border-color: {Gruvbox.ORANGE};
            }}
        """)
        lay.addWidget(self.btn_reset)

        lay.addStretch()

        self.btn_skip = NFButton("⏭")
        self.btn_skip.setToolTip("Пропустить (→)")
        self.btn_skip.setEnabled(False)
        self.btn_skip.clicked.connect(self._skip)
        self.btn_skip.setStyleSheet(f"""
            QPushButton {{
                background-color: {Gruvbox.BG2};
                padding: 8px 14px;
            }}
            QPushButton:hover {{
                background-color: {Gruvbox.BG3};
                border-color: {Gruvbox.PURPLE};
            }}
        """)
        lay.addWidget(self.btn_skip)

        parent_layout.addWidget(bar)

    def _style_start_button(self, running=False):
        if not hasattr(self, "btn_start"):
            return
        if running:
            self.btn_start.setText("⏸")
            self.btn_start.setStyleSheet(f"""
                QPushButton {{
                    font-size: 18px;
                    padding: 10px 28px;
                    background-color: {Gruvbox.ORANGE_DIM};
                    border-color: {Gruvbox.ORANGE};
                }}
                QPushButton:hover {{
                    background-color: {Gruvbox.ORANGE};
                }}
            """)
        else:
            self.btn_start.setText("▶")
            self.btn_start.setStyleSheet(f"""
                QPushButton {{
                    font-size: 18px;
                    padding: 10px 28px;
                    background-color: {Gruvbox.GREEN_DIM};
                    border-color: {Gruvbox.GREEN};
                }}
                QPushButton:hover {{
                    background-color: {Gruvbox.GREEN};
                    color: {Gruvbox.BG};
                }}
            """)

    def _load_from_path(self, path: Path):
        if not path.exists():
            if not self.minimal_mode:
                QMessageBox.warning(self, "Ошибка", f"Путь не найден: {path}")
            return

        self.images = load_images_from_path(path)

        if self.images:
            self._process_images(silent=True)
        elif not self.minimal_mode:
            QMessageBox.warning(self, "Ошибка", f"Нет изображений в: {path}")

    def _load_folder(self):
        folder = QFileDialog.getExistingDirectory(
            self, "Выберите папку с изображениями"
        )
        if folder:
            self.images = load_images_from_path(Path(folder))
            if self.images:
                self._process_images()
            else:
                QMessageBox.warning(self, "Ошибка", "Нет изображений в папке!")

    def _process_images(self, silent=False):
        if not self.images:
            return

        if self.chk_shuffle.isChecked():
            random.shuffle(self.images)

        self._prepare_session()
        self._show_current()

        if not silent and not self.minimal_mode:
            QMessageBox.information(self, "✓", f"Загружено: {len(self.images)}")

    def _prepare_session(self):
        if 0 < self.per_session < len(self.images):
            self.session_images = self.images[: self.per_session]
        else:
            self.session_images = self.images.copy()

        self.current_idx = 0
        self.done_count = 0
        self._update_counter()

    def _show_current(self):
        if not self.session_images:
            return

        path = self.session_images[self.current_idx]
        if not self.viewer.set_image(path):
            if self.current_idx < len(self.session_images) - 1:
                self.current_idx += 1
                self._show_current()

        self._update_counter()

    def _update_counter(self):
        total = len(self.session_images)
        cur = self.current_idx + 1 if self.session_images else 0
        self.lbl_counter.setText(f"{cur}/{total}")

    def resizeEvent(self, e):
        super().resizeEvent(e)
        self.countdown_overlay.setGeometry(self.viewer.geometry())
        if self.minimal_mode and hasattr(self, "minimal_overlay"):
            self.minimal_overlay.setGeometry(self.viewer.geometry())
        self._adapt()

    def _adapt(self):
        w = self.width()
        if w < self.MOBILE:
            self._set_mode("mobile")
        elif w < self.COMPACT:
            self._set_mode("compact")
        else:
            self._set_mode("desktop")

    def _set_mode(self, mode):
        if self.mode == mode:
            return
        self.mode = mode

        if self.minimal_mode:
            return

        if mode == "mobile":
            self.spin_delay.hide()
            self.chk_sound.setText("")
            self.chk_shuffle.setText("")
        elif mode == "compact":
            self.spin_delay.show()
            self.chk_sound.setText("")
            self.chk_shuffle.setText("")
        else:
            self.spin_delay.show()
            self.chk_sound.setText("🔊")
            self.chk_shuffle.setText("🔀")

        self._update_timer_display()

    def keyPressEvent(self, e):
        shift = e.modifiers() & Qt.KeyboardModifier.ShiftModifier
        ctrl = e.modifiers() & Qt.KeyboardModifier.ControlModifier

        if e.key() == Qt.Key.Key_Space:
            e.accept()
            if shift and not self.minimal_mode:
                self._start_with_countdown()
            else:
                self._toggle()
        elif e.key() == Qt.Key.Key_Right:
            e.accept()
            self._skip()
        elif e.key() == Qt.Key.Key_Left:
            e.accept()
            self._prev()
        elif e.key() == Qt.Key.Key_R:
            e.accept()
            if shift and not self.minimal_mode:
                self._reset_with_countdown()
            else:
                self._do_reset()
        elif e.key() == Qt.Key.Key_Escape:
            e.accept()
            self.close()
        elif e.key() == Qt.Key.Key_Q:
            e.accept()
            self.close()
        elif ctrl and e.key() == Qt.Key.Key_BracketLeft:
            e.accept()
            self.close()
        else:
            super().keyPressEvent(e)

    def _on_start_click(self):
        modifiers = QApplication.keyboardModifiers()
        if modifiers & Qt.KeyboardModifier.ShiftModifier:
            self._start_with_countdown()
        else:
            self._toggle()

    def _on_reset_click(self):
        modifiers = QApplication.keyboardModifiers()
        if modifiers & Qt.KeyboardModifier.ShiftModifier:
            self._reset_with_countdown()
        else:
            self._do_reset()

    def _on_time_change(self, val):
        self.sel_time = val
        self.remain = val
        if not self.running:
            suggested = get_session_count(val)
            self.spin_count.setValue(suggested)
            self.per_session = suggested
        self._update_timer_display()

    def _on_count_change(self, val):
        self.per_session = val

    def _on_delay_change(self, val):
        self.countdown_seconds = val

    def _start_with_countdown(self):
        if self.countdown_active:
            return

        if not self.session_images:
            if not self.images:
                if not self.minimal_mode:
                    QMessageBox.warning(self, "Ошибка", "Загрузите изображения!")
                return
            self._prepare_session()
            self._show_current()

        self.countdown_active = True
        self.countdown_value = self.countdown_seconds

        self.viewer.hide_image()
        self.countdown_overlay.setGeometry(self.viewer.geometry())
        self.countdown_overlay.start(self.countdown_value)

        if self.chk_sound.isChecked():
            self.sound.play_countdown()

        self.countdown_timer.start(1000)

    def _countdown_tick(self):
        self.countdown_value -= 1

        if self.countdown_value > 0:
            self.countdown_overlay.set_count(self.countdown_value)
            if self.chk_sound.isChecked():
                self.sound.play_countdown()
        else:
            self.countdown_timer.stop()
            self.countdown_overlay.hide_overlay()
            self.countdown_active = False
            self.viewer.show_image()
            self._start()

    def _reset_with_countdown(self):
        self._do_reset()
        self._start_with_countdown()

    def _toggle(self):
        if self.countdown_active:
            self.countdown_timer.stop()
            self.countdown_overlay.hide_overlay()
            self.countdown_active = False
            self.viewer.show_image()
            return

        if not self.session_images:
            if not self.images:
                if not self.minimal_mode:
                    QMessageBox.warning(self, "Ошибка", "Загрузите изображения!")
                return
            self._prepare_session()
            self._show_current()

        if not self.running:
            self._start()
        elif self.paused:
            self._resume()
        else:
            self._pause()

    def _start(self):
        self.running = True
        self.paused = False
        self.remain = self.sel_time

        self._update_btn()

        if not self.minimal_mode:
            self.btn_skip.setEnabled(True)
            self.btn_prev.setEnabled(True)
            self.spin_time.setEnabled(False)
            self.spin_count.setEnabled(False)

        if self.chk_sound.isChecked():
            self.sound.play_start()

        self.timer.start(1000)

        # Скрыть подсказку в минимальном режиме
        if self.minimal_mode and hasattr(self, "lbl_hint"):
            self.lbl_hint.hide()

    def _pause(self):
        self.paused = True
        self.timer.stop()
        self._update_btn()

        # Показать подсказку при паузе
        if self.minimal_mode and hasattr(self, "lbl_hint"):
            self.lbl_hint.setText("Space: продолжить | Esc: выход")
            self.lbl_hint.show()

    def _resume(self):
        self.paused = False
        self.timer.start(1000)
        self._update_btn()

        if self.minimal_mode and hasattr(self, "lbl_hint"):
            self.lbl_hint.hide()

    def _stop(self):
        self.running = False
        self.paused = False
        self.timer.stop()
        self._update_btn()

        if not self.minimal_mode:
            self.spin_time.setEnabled(True)
            self.spin_count.setEnabled(True)

    def _update_btn(self):
        self._style_start_button(running=self.running and not self.paused)

    def _tick(self):
        self.remain -= 1
        self._update_timer_display()

        if self.chk_sound.isChecked():
            if self.remain == 10:
                self.sound.play_warning()
            elif 0 < self.remain <= 5:
                self.sound.play_tick()

        if self.remain <= 0:
            self._on_end()

    def _update_timer_display(self):
        m, s = divmod(self.remain, 60)
        self.lbl_timer.setText(f"{m:02d}:{s:02d}")

        if self.remain <= 5:
            color = Gruvbox.RED
        elif self.remain <= 10:
            color = Gruvbox.YELLOW
        else:
            color = Gruvbox.GREEN

        if self.minimal_mode:
            self.lbl_timer.setStyleSheet(f"""
                font-size: 28px;
                font-weight: bold;
                font-family: 'Ubuntu mono', 'JetBrains Mono', 'Fira Code', 'Consolas', monospace;
                color: {color};
                background: transparent;
            """)
        else:
            sizes = {"desktop": "26px", "compact": "24px", "mobile": "20px"}
            sz = sizes.get(self.mode, "26px")
            self.lbl_timer.setStyleSheet(f"""
                font-size: {sz};
                font-weight: bold;
                font-family: 'Ubuntu mono', 'JetBrains Mono', 'Fira Code', 'Consolas', monospace;
                color: {color};
                padding: 0 8px;
            """)

    def _on_end(self):
        self.done_count += 1

        if self.chk_sound.isChecked():
            self.sound.play_end()

        self._next()

    def _next(self):
        if self.current_idx < len(self.session_images) - 1:
            self.current_idx += 1
            self._show_current()
            self.remain = self.sel_time
            self._update_timer_display()
            if self.chk_sound.isChecked():
                self.sound.play_start()
        else:
            self._stop()
            if self.auto_close:
                # Автозакрытие через небольшую задержку
                QTimer.singleShot(500, self.close)
            else:
                QMessageBox.information(
                    self, "🎉", f"Сессия завершена!\nНарисовано: {self.done_count}"
                )

    def _skip(self):
        if self.session_images and self.running:
            self._next()

    def _prev(self):
        if self.session_images and self.current_idx > 0:
            self.current_idx -= 1
            self._show_current()
            self.remain = self.sel_time
            self._update_timer_display()

    def _do_reset(self):
        self._stop()
        self.done_count = 0
        self.remain = self.sel_time

        if self.chk_shuffle.isChecked() and self.images:
            random.shuffle(self.images)

        self._prepare_session()
        self._update_timer_display()

        if self.session_images:
            self._show_current()

        if not self.minimal_mode:
            self.btn_skip.setEnabled(False)
            self.btn_prev.setEnabled(False)


# =============================================================================
# CLI
# =============================================================================
def parse_args():
    parser = argparse.ArgumentParser(
        description="Gesture Drawing Practice App",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Примеры:
  %(prog)s                              Обычный запуск
  %(prog)s -p ~/Pictures/refs           Загрузить из папки
  %(prog)s -t 60                        60 секунд на жест
  %(prog)s -t 45 -c 15                  45 сек, 15 жестов
  %(prog)s -p ./refs -t 30 -s           Путь, 30 сек, автостарт
  %(prog)s -p ./refs -m -s              Минимальный режим, автостарт
  %(prog)s -p ./refs -t 60 -c 5 -m -s   Полная настройка, минимальный режим

Минимальный режим (-m):
  • Скрывает весь интерфейс, кроме таймера и счётчика
  • Автоматически закрывается после завершения сессии
  • Управление: Space (пауза), Esc (выход), ←/→ (навигация)

Настройки по умолчанию:
  30 секунд  →  20 жестов
  60 секунд  →  10 жестов
  120 секунд →  5 жестов
        """,
    )
    parser.add_argument(
        "-p",
        "--path",
        type=str,
        help="Путь к директории с изображениями",
    )
    parser.add_argument(
        "-t",
        "--time",
        type=int,
        help="Время на жест в секундах (5-600)",
    )
    parser.add_argument(
        "-c",
        "--count",
        type=int,
        help="Количество жестов в сессии (0 = все)",
    )
    parser.add_argument(
        "-d",
        "--delay",
        type=int,
        default=None,
        help="Секунды подготовки перед стартом",
    )
    parser.add_argument(
        "-s",
        "--start",
        action="store_true",
        help="Автоматический старт с подготовкой",
    )
    parser.add_argument(
        "-m",
        "--minimal",
        action="store_true",
        help="Минимальный режим (только таймер и счётчик, автозакрытие)",
    )
    return parser.parse_args()


def main():
    args = parse_args()

    cli_args = {
        "path": args.path,
        "time": args.time,
        "count": args.count,
        "delay": args.delay,
        "start": args.start,
        "minimal": args.minimal,
    }

    app = QApplication(sys.argv)
    app.setStyle("Fusion")
    win = GestureApp(cli_args)
    win.show()
    sys.exit(app.exec())


if __name__ == "__main__":
    main()
