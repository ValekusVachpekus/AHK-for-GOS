# -*- coding: utf-8 -*-
"""
config_web.py — веб-конфигуратор для AHK-for-GOS.

Заменяет баганый config_manager.ahk. Поднимает локальный сервер на
http://localhost:8765, отдаёт web/index.html и читает/пишет config.ini в CP1251
(формат, который ожидает IniRead в main.ahk: секция [Config], кодировка cp1251).

Запуск:  python config_web.py   (или двойной клик по config_web.bat)
Прав администратора НЕ требует.
"""

import json
import os
import sys
import threading
import webbrowser
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

HOST = "localhost"
PORT = 8765

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
CONFIG_PATH = os.path.join(BASE_DIR, "config.ini")
HTML_PATH = os.path.join(BASE_DIR, "web", "index.html")

# Хвост, который дописывается к выбранной папке для формирования полного пути way.
CHATLOG_SUFFIX = r"\amazing\chatlog.txt"

# Порядок и набор ключей строго как в config.ini (их читает main.ahk).
KEYS = ["way", "CRMP_USER_NICKNAME", "poz", "dolz", "zvan", "goska"]

# Значения по умолчанию (совпадают с дефолтами IniRead в main.ahk).
DEFAULTS = {
    "way": r"C:\Amazing Games\Amazing Online\PC\amazing\chatlog.txt",
    "CRMP_USER_NICKNAME": "Vladislav_Shetkov",
    "poz": "Фантом",
    "dolz": "инспектор СР ДПС",
    "zvan": "прапорщик",
    "goska": "ГАИ",
}


def read_config():
    """Читает config.ini (CP1251) в dict. Ручной парс — configparser ломается
    на пробелах/спецсимволах в значениях и не гарантирует порядок ключей."""
    values = dict(DEFAULTS)
    if os.path.exists(CONFIG_PATH):
        with open(CONFIG_PATH, "r", encoding="cp1251") as f:
            for line in f:
                line = line.strip().lstrip("﻿")
                if not line or line.startswith("[") or "=" not in line:
                    continue
                key, _, val = line.partition("=")
                key = key.strip()
                if key in KEYS:
                    values[key] = val.strip()
    return values


def write_config(values):
    """Пишет config.ini в CP1251 с секцией [Config] и фиксированным порядком ключей."""
    lines = ["[Config]"]
    for key in KEYS:
        lines.append("{}={}".format(key, values.get(key, "")))
    with open(CONFIG_PATH, "w", encoding="cp1251", newline="\r\n") as f:
        f.write("\n".join(lines) + "\n")


def folder_from_way(way):
    """Убирает хвост \\amazing\\chatlog.txt — в форме показываем только папку."""
    low = way.lower()
    if low.endswith(CHATLOG_SUFFIX.lower()):
        return way[: -len(CHATLOG_SUFFIX)]
    return way


def way_from_folder(folder):
    """Собирает полный путь way из выбранной папки."""
    folder = folder.rstrip("\\/")
    return folder + CHATLOG_SUFFIX


def pick_folder():
    """Нативный диалог выбора папки (tkinter из stdlib). Возвращает путь или ''."""
    try:
        import tkinter as tk
        from tkinter import filedialog
    except Exception:
        return ""
    root = tk.Tk()
    root.withdraw()
    root.attributes("-topmost", True)
    path = filedialog.askdirectory(title="Выберите папку с игрой (внутри неё \\amazing)")
    root.destroy()
    return path or ""


class Handler(BaseHTTPRequestHandler):
    def log_message(self, *args):
        pass  # тихо

    def _send_json(self, obj, status=200):
        body = json.dumps(obj, ensure_ascii=False).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def _read_body(self):
        length = int(self.headers.get("Content-Length", 0))
        if not length:
            return {}
        raw = self.rfile.read(length).decode("utf-8")
        return json.loads(raw)

    def do_GET(self):
        if self.path == "/" or self.path.startswith("/index.html"):
            try:
                with open(HTML_PATH, "rb") as f:
                    body = f.read()
            except FileNotFoundError:
                self.send_error(404, "web/index.html not found")
                return
            self.send_response(200)
            self.send_header("Content-Type", "text/html; charset=utf-8")
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)
        elif self.path == "/config":
            values = read_config()
            values["folder"] = folder_from_way(values.get("way", ""))
            self._send_json(values)
        else:
            self.send_error(404)

    def do_POST(self):
        if self.path == "/pick-folder":
            self._send_json({"folder": pick_folder()})
        elif self.path == "/save":
            try:
                data = self._read_body()
            except Exception as e:
                self._send_json({"ok": False, "error": str(e)}, status=400)
                return
            folder = (data.get("folder") or "").strip()
            values = {
                "way": way_from_folder(folder) if folder else DEFAULTS["way"],
                "CRMP_USER_NICKNAME": (data.get("CRMP_USER_NICKNAME") or "").strip(),
                "poz": (data.get("poz") or "").strip(),
                "dolz": (data.get("dolz") or "").strip(),
                "zvan": (data.get("zvan") or "").strip(),
                "goska": (data.get("goska") or "").strip(),
            }
            try:
                write_config(values)
            except Exception as e:
                self._send_json({"ok": False, "error": str(e)}, status=500)
                return
            self._send_json({"ok": True, "way": values["way"]})
        else:
            self.send_error(404)


def main():
    if not os.path.exists(HTML_PATH):
        print("Не найден web/index.html рядом со скриптом:", HTML_PATH)
        sys.exit(1)
    server = ThreadingHTTPServer((HOST, PORT), Handler)
    url = "http://{}:{}/".format(HOST, PORT)
    print("Конфигуратор запущен:", url)
    print("Закройте окно браузера и нажмите Ctrl+C здесь, чтобы остановить.")
    threading.Timer(0.5, lambda: webbrowser.open(url)).start()
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        server.shutdown()


if __name__ == "__main__":
    main()
