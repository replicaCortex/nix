"""
Gesture Drawing Practice App (PyQt6)
Минималистичное приложение для практики рисования жестов

CLI:
    python main.py                     # Обычный запуск
    python main.py -t 60               # 60 секунд на рисунок
    python main.py -c 10               # 10 фото в сессии
    python main.py -t 30 -c 20         # 30 сек, 20 фото
    python main.py -t 120 -c 5 -d 5    # 2 мин, 5 фото, 5 сек подготовка
    python main.py --start             # Автостарт с задержкой
"""

import argparse
import array
import json
import math
import os
import random
import sys
from pathlib import Path

from PyQt6.QtCore import QRect, Qt, QTimer
from PyQt6.QtGui import QColor, QFont, QPainter, QPixmap
from PyQt6.QtWidgets import (
    QApplication,
    QCheckBox,
    QComboBox,
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

CONFIG_FILE = Path(__file__).parent / "gesture_config.json"


class ConfigManager:
    DEFAULT = {
        "last_folder": "",
        "last_files": [],
        "session_counts": {"30": 20, "60": 15, "120": 10, "300": 5},
        "sound_enabled": True,
        "shuffle_enabled": True,
        "last_time": "30с",
        "countdown_seconds": 3,
    }

    def __init__(self, path):
        self.path = Path(path)
        self.data = self._load()

    def _load(self):
        try:
            if self.path.exists():
                with open(self.path, "r", encoding="utf-8") as f:
                    loaded = json.load(f)
                    config = self.DEFAULT.copy()
                    config.update(loaded)
                    for k in self.DEFAULT["session_counts"]:
                        if k not in config.get("session_counts", {}):
                            config.setdefault("session_counts", {})[k] = self.DEFAULT[
                                "session_counts"
                            ][k]
                    return config
        except:
            pass
        return self.DEFAULT.copy()

    def save(self):
        try:
            with open(self.path, "w", encoding="utf-8") as f:
                json.dump(self.data, f, ensure_ascii=False, indent=2)
        except:
            pass

    def get(self, key, default=None):
        return self.data.get(key, default)

    def set(self, key, value):
        self.data[key] = value
        self.save()

    def get_session_count(self, time_sec):
        return self.data.get("session_counts", {}).get(str(time_sec), 10)

    def set_session_count(self, time_sec, count):
        if "session_counts" not in self.data:
            self.data["session_counts"] = {}
        self.data["session_counts"][str(time_sec)] = count
        self.save()


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
        s = self._beep(880, 150, 0.3)
        if s:
            s.play()

    def play_warning(self):
        s = self._beep(660, 100, 0.3)
        if s:
            s.play()

    def play_end(self):
        s = self._beep(440, 200, 0.4)
        if s:
            s.play()
            QTimer.singleShot(250, lambda: s.play())

    def play_tick(self):
        s = self._beep(1000, 50, 0.2)
        if s:
            s.play()

    def play_countdown(self):
        s = self._beep(550, 100, 0.25)
        if s:
            s.play()


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
        self.setStyleSheet("""
            QLabel {
                background-color: #2b2b2b;
                border: 2px solid #404040;
                border-radius: 8px;
                color: #666;
                font-size: 16px;
            }
        """)

    def set_image(self, path):
        try:
            px = QPixmap(path)
            if px.isNull():
                return False
            self.original_pixmap = px
            self._update_scaled()
            self.setStyleSheet("""
                QLabel {
                    background-color: #2b2b2b;
                    border: 2px solid #404040;
                    border-radius: 8px;
                }
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
        """Скрыть изображение, показать чёрный фон"""
        self.clear()
        self.setStyleSheet("""
            QLabel {
                background-color: #1a1a1a;
                border: 2px solid #404040;
                border-radius: 8px;
            }
        """)

    def show_image(self):
        """Показать изображение обратно"""
        if self.original_pixmap:
            self._update_scaled()
            self.setStyleSheet("""
                QLabel {
                    background-color: #2b2b2b;
                    border: 2px solid #404040;
                    border-radius: 8px;
                }
            """)

    def resizeEvent(self, e):
        super().resizeEvent(e)
        if self.original_pixmap and self.pixmap() and not self.pixmap().isNull():
            self._update_scaled()


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
        painter.fillRect(self.rect(), QColor(0, 0, 0, 220))
        painter.setPen(QColor("#3498db"))
        font = QFont("Arial", 100, QFont.Weight.Bold)
        painter.setFont(font)
        painter.drawText(self.rect(), Qt.AlignmentFlag.AlignCenter, str(self.count))


class NFButton(QPushButton):
    def __init__(self, *a, **kw):
        super().__init__(*a, **kw)
        self.setFocusPolicy(Qt.FocusPolicy.NoFocus)


class NFComboBox(QComboBox):
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


class GestureApp(QMainWindow):
    COMPACT = 500
    MOBILE = 380

    def __init__(self, cli_args=None):
        super().__init__()

        self.cli_args = cli_args or {}
        self.config = ConfigManager(CONFIG_FILE)

        self.images = []
        self.session_images = []
        self.current_idx = 0
        self.times = {"30с": 30, "1м": 60, "2м": 120, "5м": 300}
        self.times_reverse = {30: "30с", 60: "1м", 120: "2м", 300: "5м"}
        self.sel_time = 30
        self.remain = 30
        self.running = False
        self.paused = False
        self.done_count = 0
        self.per_session = self.config.get_session_count(30)
        self.mode = "desktop"

        self.countdown_seconds = self.config.get("countdown_seconds", 3)
        self.countdown_active = False
        self.countdown_value = self.countdown_seconds
        self.countdown_timer = QTimer()
        self.countdown_timer.timeout.connect(self._countdown_tick)

        self.sound = SoundManager()

        self.timer = QTimer()
        self.timer.timeout.connect(self._tick)

        self._init_ui()
        self._apply_cli_args()
        self._load_last_images()

        # Автостарт если указан в CLI
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
        layout.setContentsMargins(8, 8, 8, 8)
        layout.setSpacing(6)

        self._create_top_bar(layout)
        self._create_image_area(layout)
        self._create_bottom_bar(layout)

        self.setFocus()
        QTimer.singleShot(50, self._adapt)

    def _styles(self):
        return """
            QMainWindow, QWidget {
                background-color: #1e1e1e;
                color: #fff;
                font-family: 'Segoe UI', Arial;
            }
            QPushButton {
                background-color: #3498db;
                color: white;
                border: none;
                padding: 6px 10px;
                border-radius: 5px;
                font-size: 13px;
                font-weight: bold;
            }
            QPushButton:hover { background-color: #2980b9; }
            QPushButton:pressed { background-color: #21618c; }
            QPushButton:disabled { background-color: #444; color: #777; }
            QComboBox, QSpinBox {
                background-color: #2b2b2b;
                border: 1px solid #404040;
                border-radius: 4px;
                padding: 4px 6px;
                font-size: 12px;
                min-width: 45px;
            }
            QComboBox:hover, QSpinBox:hover { border-color: #3498db; }
            QComboBox::drop-down { border: none; width: 18px; }
            QComboBox QAbstractItemView {
                background-color: #2b2b2b;
                selection-background-color: #3498db;
            }
            QCheckBox { font-size: 13px; }
            QCheckBox::indicator {
                width: 16px; height: 16px;
                border-radius: 3px;
                border: 1px solid #404040;
                background-color: #2b2b2b;
            }
            QCheckBox::indicator:checked {
                background-color: #3498db;
                border-color: #3498db;
            }
        """

    def _create_top_bar(self, parent_layout):
        bar = QWidget()
        bar.setStyleSheet("background-color: #252525; border-radius: 6px;")
        bar.setFixedHeight(44)
        lay = QHBoxLayout(bar)
        lay.setContentsMargins(8, 4, 8, 4)
        lay.setSpacing(4)

        # Загрузка
        self.btn_folder = NFButton("📁")
        self.btn_folder.setToolTip("Папка")
        self.btn_folder.setFixedSize(32, 32)
        self.btn_folder.clicked.connect(self._load_folder)
        lay.addWidget(self.btn_folder)

        self.btn_files = NFButton("🖼")
        self.btn_files.setToolTip("Файлы")
        self.btn_files.setFixedSize(32, 32)
        self.btn_files.clicked.connect(self._load_files)
        lay.addWidget(self.btn_files)

        lay.addSpacing(4)

        # Время
        self.combo_time = NFComboBox()
        self.combo_time.addItems(list(self.times.keys()))
        self.combo_time.setToolTip("Время")
        self.combo_time.setFixedWidth(52)
        self.combo_time.currentTextChanged.connect(self._on_time_change)
        lay.addWidget(self.combo_time)

        # Количество фото
        self.spin_count = NFSpinBox()
        self.spin_count.setRange(0, 999)
        self.spin_count.setSpecialValueText("∞")
        self.spin_count.setToolTip("Фото в сессии (0=все)")
        self.spin_count.setFixedWidth(48)
        self.spin_count.valueChanged.connect(self._on_count_change)
        lay.addWidget(self.spin_count)

        # Задержка
        self.spin_delay = NFSpinBox()
        self.spin_delay.setRange(1, 30)
        self.spin_delay.setValue(self.countdown_seconds)
        self.spin_delay.setToolTip("Секунды подготовки")
        self.spin_delay.setFixedWidth(40)
        self.spin_delay.setPrefix("⏱")
        self.spin_delay.valueChanged.connect(self._on_delay_change)
        lay.addWidget(self.spin_delay)

        # Чекбоксы
        self.chk_sound = NFCheckBox("🔊")
        self.chk_sound.setToolTip("Звук")
        self.chk_sound.setChecked(self.config.get("sound_enabled", True))
        self.chk_sound.stateChanged.connect(
            lambda s: self.config.set("sound_enabled", s == 2)
        )
        lay.addWidget(self.chk_sound)

        self.chk_shuffle = NFCheckBox("🔀")
        self.chk_shuffle.setToolTip("Перемешать")
        self.chk_shuffle.setChecked(self.config.get("shuffle_enabled", True))
        self.chk_shuffle.stateChanged.connect(
            lambda s: self.config.set("shuffle_enabled", s == 2)
        )
        lay.addWidget(self.chk_shuffle)

        lay.addStretch()

        # Таймер
        self.lbl_timer = QLabel("00:30")
        self.lbl_timer.setStyleSheet("""
            font-size: 26px; font-weight: bold;
            font-family: 'Consolas', monospace;
            color: #2ecc71; padding: 0 8px;
        """)
        lay.addWidget(self.lbl_timer)

        lay.addStretch()

        # Счётчик
        self.lbl_counter = QLabel("0/0")
        self.lbl_counter.setStyleSheet(
            "font-size: 13px; font-weight: bold; color: #3498db;"
        )
        lay.addWidget(self.lbl_counter)

        lay.addSpacing(4)

        self.lbl_done = QLabel("✓0")
        self.lbl_done.setStyleSheet("font-size: 12px; color: #27ae60;")
        lay.addWidget(self.lbl_done)

        parent_layout.addWidget(bar)

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

    def _create_bottom_bar(self, parent_layout):
        bar = QWidget()
        bar.setStyleSheet("background-color: #252525; border-radius: 6px;")
        bar.setFixedHeight(50)
        lay = QHBoxLayout(bar)
        lay.setContentsMargins(10, 6, 10, 6)
        lay.setSpacing(8)

        self.btn_prev = NFButton("⏮")
        self.btn_prev.setToolTip("Предыдущее (←)")
        self.btn_prev.setEnabled(False)
        self.btn_prev.clicked.connect(self._prev)
        self.btn_prev.setStyleSheet("background-color: #555; padding: 8px 14px;")
        lay.addWidget(self.btn_prev)

        lay.addStretch()

        self.btn_start = NFButton("▶")
        self.btn_start.setToolTip("Space=старт | Shift+Space=с подготовкой")
        self.btn_start.setStyleSheet("""
            QPushButton {
                font-size: 18px; padding: 10px 28px;
                background-color: #27ae60;
            }
            QPushButton:hover { background-color: #219a52; }
        """)
        self.btn_start.clicked.connect(self._on_start_click)
        lay.addWidget(self.btn_start)

        self.btn_reset = NFButton("🔄")
        self.btn_reset.setToolTip("Сброс (R) | Shift+R=с подготовкой")
        self.btn_reset.setFixedSize(36, 36)
        self.btn_reset.clicked.connect(self._on_reset_click)
        self.btn_reset.setStyleSheet("background-color: #7f8c8d;")
        lay.addWidget(self.btn_reset)

        lay.addStretch()

        self.btn_skip = NFButton("⏭")
        self.btn_skip.setToolTip("Пропустить (→)")
        self.btn_skip.setEnabled(False)
        self.btn_skip.clicked.connect(self._skip)
        self.btn_skip.setStyleSheet("background-color: #555; padding: 8px 14px;")
        lay.addWidget(self.btn_skip)

        parent_layout.addWidget(bar)

    def _apply_cli_args(self):
        """Применить аргументы командной строки"""
        # Время
        if "time" in self.cli_args and self.cli_args["time"]:
            t = self.cli_args["time"]
            if t in self.times_reverse:
                self.sel_time = t
                self.remain = t
                self.combo_time.setCurrentText(self.times_reverse[t])

        # Количество
        if "count" in self.cli_args and self.cli_args["count"] is not None:
            self.per_session = self.cli_args["count"]
            self.spin_count.setValue(self.per_session)

        # Задержка
        if "delay" in self.cli_args and self.cli_args["delay"]:
            self.countdown_seconds = self.cli_args["delay"]
            self.spin_delay.setValue(self.countdown_seconds)

    def _load_last_images(self):
        """Загрузить последние изображения при старте"""
        # Сначала загружаем настройки времени
        last = self.config.get("last_time", "30с")
        if last in self.times and "time" not in self.cli_args:
            self.combo_time.setCurrentText(last)
            self.sel_time = self.times[last]
            self.remain = self.sel_time

        # Загружаем количество для текущего времени
        if "count" not in self.cli_args:
            self.per_session = self.config.get_session_count(self.sel_time)
            self.spin_count.setValue(self.per_session)

        self._update_timer_display()

        # Пробуем загрузить изображения
        last_folder = self.config.get("last_folder", "")
        last_files = self.config.get("last_files", [])

        if last_folder and Path(last_folder).exists():
            self.images = []
            valid = {".jpg", ".jpeg", ".png", ".gif", ".bmp", ".webp"}
            for f in Path(last_folder).iterdir():
                if f.suffix.lower() in valid:
                    self.images.append(str(f))
            if self.images:
                self._process_images(save=False, silent=True)
                return

        if last_files:
            self.images = [f for f in last_files if Path(f).exists()]
            if self.images:
                self._process_images(save=False, silent=True)

    def resizeEvent(self, e):
        super().resizeEvent(e)
        self.countdown_overlay.setGeometry(self.viewer.geometry())
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

        if mode == "mobile":
            self.spin_delay.hide()
            self.chk_sound.setText("")
            self.chk_shuffle.setText("")
            self.lbl_timer.setStyleSheet("""
                font-size: 20px; font-weight: bold;
                font-family: 'Consolas', monospace;
                color: #2ecc71; padding: 0 4px;
            """)
        elif mode == "compact":
            self.spin_delay.show()
            self.chk_sound.setText("")
            self.chk_shuffle.setText("")
            self.lbl_timer.setStyleSheet("""
                font-size: 24px; font-weight: bold;
                font-family: 'Consolas', monospace;
                color: #2ecc71; padding: 0 6px;
            """)
        else:
            self.spin_delay.show()
            self.chk_sound.setText("🔊")
            self.chk_shuffle.setText("🔀")
            self.lbl_timer.setStyleSheet("""
                font-size: 26px; font-weight: bold;
                font-family: 'Consolas', monospace;
                color: #2ecc71; padding: 0 8px;
            """)
        self._update_timer_display()

    def keyPressEvent(self, e):
        shift = e.modifiers() & Qt.KeyboardModifier.ShiftModifier

        if e.key() == Qt.Key.Key_Space:
            e.accept()
            if shift:
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
            if shift:
                self._reset_with_countdown()
            else:
                self._do_reset()
        else:
            super().keyPressEvent(e)

    def _on_start_click(self):
        """Клик по кнопке старт"""
        modifiers = QApplication.keyboardModifiers()
        if modifiers & Qt.KeyboardModifier.ShiftModifier:
            self._start_with_countdown()
        else:
            self._toggle()

    def _on_reset_click(self):
        """Клик по кнопке сброс"""
        modifiers = QApplication.keyboardModifiers()
        if modifiers & Qt.KeyboardModifier.ShiftModifier:
            self._reset_with_countdown()
        else:
            self._do_reset()

    def _on_delay_change(self, val):
        self.countdown_seconds = val
        self.config.set("countdown_seconds", val)

    def _start_with_countdown(self):
        if self.countdown_active:
            return

        if not self.session_images:
            if not self.images:
                QMessageBox.warning(self, "Ошибка", "Загрузите изображения!")
                return
            self._prepare_session()
            self._show_current()

        self.countdown_active = True
        self.countdown_value = self.countdown_seconds

        # Скрываем изображение
        self.viewer.hide_image()

        # Показываем оверлей
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
            # Показываем изображение обратно
            self.viewer.show_image()
            self._start()

    def _reset_with_countdown(self):
        self._do_reset()
        self._start_with_countdown()

    def _on_time_change(self, text):
        self.sel_time = self.times[text]
        self.remain = self.sel_time
        self.per_session = self.config.get_session_count(self.sel_time)
        self.spin_count.blockSignals(True)
        self.spin_count.setValue(self.per_session)
        self.spin_count.blockSignals(False)
        self.config.set("last_time", text)
        self._update_timer_display()

    def _on_count_change(self, val):
        self.per_session = val
        self.config.set_session_count(self.sel_time, val)

    def _load_folder(self):
        last = self.config.get("last_folder", "")
        start = last if last and Path(last).parent.exists() else ""
        folder = QFileDialog.getExistingDirectory(self, "Папка", start)
        if folder:
            self.images = []
            valid = {".jpg", ".jpeg", ".png", ".gif", ".bmp", ".webp"}
            for f in Path(folder).iterdir():
                if f.suffix.lower() in valid:
                    self.images.append(str(f))
            if self.images:
                self.config.set("last_folder", folder)
                self.config.set("last_files", [])
            self._process_images()

    def _load_files(self):
        last = self.config.get("last_folder", "")
        start = last if last and Path(last).exists() else ""
        files, _ = QFileDialog.getOpenFileNames(
            self,
            "Файлы",
            start,
            "Изображения (*.jpg *.jpeg *.png *.gif *.bmp *.webp);;Все (*.*)",
        )
        if files:
            self.images = files
            self.config.set("last_files", files)
            self.config.set("last_folder", str(Path(files[0]).parent))
            self._process_images()

    def _process_images(self, save=True, silent=False):
        if not self.images:
            if not silent:
                QMessageBox.warning(self, "Ошибка", "Нет изображений!")
            return
        if self.chk_shuffle.isChecked():
            random.shuffle(self.images)
        self._prepare_session()
        self._show_current()
        if not silent:
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

    def _toggle(self):
        if self.countdown_active:
            self.countdown_timer.stop()
            self.countdown_overlay.hide_overlay()
            self.countdown_active = False
            self.viewer.show_image()
            return

        if not self.session_images:
            if not self.images:
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
        self.btn_skip.setEnabled(True)
        self.btn_prev.setEnabled(True)
        self.combo_time.setEnabled(False)
        self.spin_count.setEnabled(False)

        if self.chk_sound.isChecked():
            self.sound.play_start()

        self.timer.start(1000)

    def _pause(self):
        self.paused = True
        self.timer.stop()
        self._update_btn()

    def _resume(self):
        self.paused = False
        self.timer.start(1000)
        self._update_btn()

    def _stop(self):
        self.running = False
        self.paused = False
        self.timer.stop()
        self._update_btn()
        self.combo_time.setEnabled(True)
        self.spin_count.setEnabled(True)

    def _update_btn(self):
        if self.running and not self.paused:
            self.btn_start.setText("⏸")
            self.btn_start.setStyleSheet("""
                QPushButton {
                    font-size: 18px; padding: 10px 28px;
                    background-color: #e67e22;
                }
                QPushButton:hover { background-color: #d35400; }
            """)
        else:
            self.btn_start.setText("▶")
            self.btn_start.setStyleSheet("""
                QPushButton {
                    font-size: 18px; padding: 10px 28px;
                    background-color: #27ae60;
                }
                QPushButton:hover { background-color: #219a52; }
            """)

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
            c = "#e74c3c"
        elif self.remain <= 10:
            c = "#f39c12"
        else:
            c = "#2ecc71"

        sizes = {"desktop": "26px", "compact": "24px", "mobile": "20px"}
        sz = sizes.get(self.mode, "26px")
        pads = {"desktop": "8px", "compact": "6px", "mobile": "4px"}
        pad = pads.get(self.mode, "8px")

        self.lbl_timer.setStyleSheet(f"""
            font-size: {sz}; font-weight: bold;
            font-family: 'Consolas', monospace;
            color: {c}; padding: 0 {pad};
        """)

    def _on_end(self):
        self.done_count += 1
        self.lbl_done.setText(f"✓{self.done_count}")

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
            QMessageBox.information(self, "🎉", f"Готово: {self.done_count}")

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
        self.lbl_done.setText("✓0")

        if self.session_images:
            self._show_current()

        self.btn_skip.setEnabled(False)
        self.btn_prev.setEnabled(False)

    def closeEvent(self, e):
        self.config.save()
        super().closeEvent(e)


def parse_args():
    parser = argparse.ArgumentParser(
        description="Gesture Drawing Practice App",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Примеры:
  python main.py                    Обычный запуск
  python main.py -t 60              60 секунд на рисунок
  python main.py -c 10              10 фото в сессии
  python main.py -t 30 -c 20 -s     30 сек, 20 фото, автостарт
  python main.py -t 120 -d 5 -s     2 мин, 5 сек подготовка, автостарт
        """,
    )
    parser.add_argument(
        "-t",
        "--time",
        type=int,
        choices=[30, 60, 120, 300],
        help="Время на рисунок (30, 60, 120, 300 секунд)",
    )
    parser.add_argument(
        "-c", "--count", type=int, help="Количество фото в сессии (0 = все)"
    )
    parser.add_argument(
        "-d",
        "--delay",
        type=int,
        default=None,
        help="Секунды подготовки перед стартом (по умолчанию из настроек)",
    )
    parser.add_argument(
        "-s", "--start", action="store_true", help="Автоматический старт с задержкой"
    )

    return parser.parse_args()


def main():
    args = parse_args()

    cli_args = {
        "time": args.time,
        "count": args.count,
        "delay": args.delay,
        "start": args.start,
    }

    app = QApplication(sys.argv)
    app.setStyle("Fusion")
    win = GestureApp(cli_args)
    win.show()
    sys.exit(app.exec())


if __name__ == "__main__":
    main()
