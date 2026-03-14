#!/usr/bin/env python3
"""
Радиальное меню с секторами для Wayland — Gruvbox тема
"""

import gi

gi.require_version("Gdk", "3.0")
gi.require_version("Gtk", "3.0")
gi.require_version("GtkLayerShell", "0.1")
import math
import subprocess

from gi.repository import Gdk, Gtk, GtkLayerShell


# Gruvbox Dark цвета
class Gruvbox:
    # Фон
    bg_hard = (0.16, 0.15, 0.13, 0.95)  # #282828
    bg = (0.18, 0.17, 0.15, 0.95)  # #32302f
    bg_soft = (0.20, 0.19, 0.17, 0.95)  # #3c3836
    bg1 = (0.26, 0.25, 0.23, 0.95)  # #504945
    bg2 = (0.33, 0.32, 0.29, 0.95)  # #665c54

    # Передний план
    fg = (0.92, 0.86, 0.70, 1.0)  # #ebdbb2
    fg0 = (0.98, 0.95, 0.85, 1.0)  # #fbf1c7
    fg2 = (0.83, 0.77, 0.63, 1.0)  # #d5c4a1
    fg3 = (0.74, 0.68, 0.55, 1.0)  # #bdae93
    fg4 = (0.66, 0.60, 0.47, 1.0)  # #a89984

    # Акценты
    red = (0.80, 0.14, 0.11, 1.0)  # #cc241d
    red_light = (0.98, 0.29, 0.20, 1.0)  # #fb4934
    green = (0.60, 0.59, 0.10, 1.0)  # #98971a
    green_light = (0.72, 0.73, 0.15, 1.0)  # #b8bb26
    yellow = (0.84, 0.60, 0.13, 1.0)  # #d79921
    yellow_light = (0.98, 0.74, 0.02, 1.0)  # #fabd2f
    blue = (0.27, 0.52, 0.53, 1.0)  # #458588
    blue_light = (0.51, 0.65, 0.60, 1.0)  # #83a598
    purple = (0.69, 0.38, 0.53, 1.0)  # #b16286
    purple_light = (0.83, 0.53, 0.64, 1.0)  # #d3869b
    aqua = (0.41, 0.62, 0.42, 1.0)  # #689d6a
    aqua_light = (0.56, 0.75, 0.49, 1.0)  # #8ec07c
    orange = (0.84, 0.36, 0.05, 1.0)  # #d65d0e
    orange_light = (0.98, 0.46, 0.09, 1.0)  # #fe8019


class RadialMenu(Gtk.Window):
    def __init__(self):
        super().__init__()

        self.menu_items = [
            {"icon": "Pcmanfm", "label": "Pcmanfm", "cmd": "pcmanfm"},
            {"icon": "Krita", "label": "Krita", "cmd": "krita"},
            {"icon": "Gimp", "label": "Gimp", "cmd": "gimp"},
            {"icon": "Zen", "label": "Zen", "cmd": "zen"},
        ]

        self.inner_radius = 50
        self.outer_radius = 150
        self.center_radius = 40
        self.hovered_item = -1
        self.clicked = False

        # Layer Shell
        GtkLayerShell.init_for_window(self)
        GtkLayerShell.set_layer(self, GtkLayerShell.Layer.OVERLAY)
        GtkLayerShell.set_keyboard_mode(self, GtkLayerShell.KeyboardMode.EXCLUSIVE)

        # Прозрачность
        self.set_app_paintable(True)
        screen = self.get_screen()
        visual = screen.get_rgba_visual()
        if visual:
            self.set_visual(visual)

        self.set_decorated(False)
        size = self.outer_radius * 2 + 60
        self.set_default_size(size, size)

        # Рисование
        self.drawing_area = Gtk.DrawingArea()
        self.drawing_area.set_size_request(size, size)
        self.drawing_area.connect("draw", self.on_draw)
        self.add(self.drawing_area)

        # События
        self.add_events(
            Gdk.EventMask.POINTER_MOTION_MASK | Gdk.EventMask.BUTTON_PRESS_MASK
        )
        self.connect("motion-notify-event", self.on_motion)
        self.connect("button-press-event", self.on_click)
        self.connect("key-press-event", self.on_key)

        self.show_all()

    def get_sector_angles(self, index):
        """Возвращает начальный и конечный угол сектора"""
        n = len(self.menu_items)
        sector_size = 2 * math.pi / n
        start = -math.pi / 2 + index * sector_size
        end = start + sector_size
        return start, end

    def on_draw(self, widget, cr):
        w, h = widget.get_allocated_width(), widget.get_allocated_height()
        cx, cy = w / 2, h / 2
        n = len(self.menu_items)

        # Прозрачный фон
        cr.set_source_rgba(0, 0, 0, 0)
        cr.set_operator(0)
        cr.paint()
        cr.set_operator(1)

        # Рисуем секторы
        for i, item in enumerate(self.menu_items):
            start_angle, end_angle = self.get_sector_angles(i)

            # Цвет сектора — Gruvbox
            if i == self.hovered_item:
                cr.set_source_rgba(*Gruvbox.orange_light)
            else:
                cr.set_source_rgba(*Gruvbox.bg1)

            # Рисуем сектор
            cr.move_to(
                cx + self.inner_radius * math.cos(start_angle),
                cy + self.inner_radius * math.sin(start_angle),
            )
            cr.arc(cx, cy, self.outer_radius, start_angle, end_angle)
            cr.arc_negative(cx, cy, self.inner_radius, end_angle, start_angle)
            cr.close_path()
            cr.fill()

            # Граница сектора
            cr.set_source_rgba(*Gruvbox.bg2)
            cr.set_line_width(2)
            cr.move_to(
                cx + self.inner_radius * math.cos(start_angle),
                cy + self.inner_radius * math.sin(start_angle),
            )
            cr.arc(cx, cy, self.outer_radius, start_angle, end_angle)
            cr.arc_negative(cx, cy, self.inner_radius, end_angle, start_angle)
            cr.close_path()
            cr.stroke()

            # Иконка в центре сектора
            mid_angle = (start_angle + end_angle) / 2
            icon_radius = (self.inner_radius + self.outer_radius) / 2
            icon_x = cx + icon_radius * math.cos(mid_angle)
            icon_y = cy + icon_radius * math.sin(mid_angle)

            # Цвет текста
            if i == self.hovered_item:
                cr.set_source_rgba(*Gruvbox.bg_hard)
            else:
                cr.set_source_rgba(*Gruvbox.fg)

            cr.select_font_face("Ubuntu mono", 0, 0)
            cr.set_font_size(18)
            ext = cr.text_extents(item["icon"])
            cr.move_to(icon_x - ext.width / 2, icon_y + ext.height / 3)
            cr.show_text(item["icon"])

            # Подпись при наведении
            if i == self.hovered_item:
                cr.set_source_rgba(*Gruvbox.fg0)
                cr.select_font_face("Ubuntu mono", 0, 1)  # Bold
                cr.set_font_size(12)
                label_radius = self.outer_radius + 18
                label_x = cx + label_radius * math.cos(mid_angle)
                label_y = cy + label_radius * math.sin(mid_angle)
                ext = cr.text_extents(item["label"])
                cr.move_to(label_x - ext.width / 2, label_y + ext.height / 3)
                cr.show_text(item["label"])

        # Центральная кнопка
        if self.hovered_item == -2:
            cr.set_source_rgba(*Gruvbox.red_light)
        else:
            cr.set_source_rgba(*Gruvbox.bg_hard)
        cr.arc(cx, cy, self.center_radius, 0, 2 * math.pi)
        cr.fill()

        # Обводка центральной кнопки
        cr.set_source_rgba(*Gruvbox.bg2)
        cr.set_line_width(2)
        cr.arc(cx, cy, self.center_radius, 0, 2 * math.pi)
        cr.stroke()

        # Крестик
        if self.hovered_item == -2:
            cr.set_source_rgba(*Gruvbox.bg_hard)
        else:
            cr.set_source_rgba(*Gruvbox.fg4)
        cr.set_line_width(3)
        s = 12
        cr.move_to(cx - s, cy - s)
        cr.line_to(cx + s, cy + s)
        cr.move_to(cx + s, cy - s)
        cr.line_to(cx - s, cy + s)
        cr.stroke()

    def get_sector_at(self, x, y):
        """Определяет сектор по координатам"""
        w = self.drawing_area.get_allocated_width()
        h = self.drawing_area.get_allocated_height()
        cx, cy = w / 2, h / 2

        dx, dy = x - cx, y - cy
        dist = math.hypot(dx, dy)

        if dist < self.center_radius:
            return -2

        if dist < self.inner_radius or dist > self.outer_radius:
            return -1

        angle = math.atan2(dy, dx)

        n = len(self.menu_items)
        for i in range(n):
            start, end = self.get_sector_angles(i)
            a = angle

            if start < -math.pi / 2 and end > -math.pi / 2:
                if start <= a <= end:
                    return i
            else:
                while a < start:
                    a += 2 * math.pi
                while a > start + 2 * math.pi:
                    a -= 2 * math.pi

                if start <= a <= end:
                    return i

        return -1

    def on_motion(self, widget, event):
        old = self.hovered_item
        self.hovered_item = self.get_sector_at(event.x, event.y)

        if old != self.hovered_item:
            self.drawing_area.queue_draw()

    def on_click(self, widget, event):
        if self.clicked:
            return

        sector = self.get_sector_at(event.x, event.y)

        if sector == -2:
            self.clicked = True
            Gtk.main_quit()
        elif sector >= 0:
            self.clicked = True
            cmd = self.menu_items[sector]["cmd"]
            subprocess.Popen(
                cmd.split(),
                start_new_session=True,
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
            )
            Gtk.main_quit()

    def on_key(self, widget, event):
        if event.keyval == Gdk.KEY_Escape:
            Gtk.main_quit()
            return True
        return False


if __name__ == "__main__":
    RadialMenu()
    Gtk.main()
