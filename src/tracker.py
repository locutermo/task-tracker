import re
import time
import pywinctl as pwc
from datetime import datetime
from .config import Config
from .database import DatabaseHandler
from .idle_detector import IdleDetector


class ActivityTracker:
    def __init__(self):
        self.db = DatabaseHandler()
        self.idle_detector = IdleDetector()
        self.last_poll_time = time.time()
        self.running = False

    def _clean_window_data(self, app_name, raw_title):
        title = raw_title.strip()

        patterns = [
            r" - Google Chrome$",
            r" - Microsoft? Edge$",
            r" - Mozilla Firefox$",
            r" \| Microsoft Teams$",
            r" - Word$",
            r" - Outlook$",
            r" - Excel$",
        ]

        for pattern in patterns:
            title = re.sub(pattern, "", title, flags=re.IGNORECASE)

        if "Teams" in app_name:
            title = re.sub(r"^\(\d+\)\s*", "", title)

        return title.strip()

    def get_active_window_info(self):
        try:
            active_window = pwc.getActiveWindow()
            if active_window:
                app_name = active_window.getAppName()
                raw_title = active_window.title

                clean_title = self._clean_window_data(app_name, raw_title)
                return {"app": app_name, "title": clean_title, "raw_title": raw_title}
        except Exception as e:
            print(f"Error detectando ventana: {e}")
            return None
        return None

    def start(self):
        try:
            self.running = True
            self.idle_detector.start()

            print(
                f"Iniciando Tracker... (Intervalo: {Config.POLL_INTERVAL}s, Idle: {300}s)"
            )
            print("Presiona Ctrl+C para detener.")

            while self.running:
                window_info = self.get_active_window_info()

                if window_info:
                    app_name = window_info["app"]
                    title = window_info["title"]

                    meeting_keywords = [
                        "Webex",
                        "Zoom",
                        "Meet",
                        "Reunión",
                        "Llamada",
                        "Meeting",
                        "Netflix",
                        "YouTube",
                        "Disney+",
                        "HBO",
                        "Prime Video",
                    ]
                    is_meeting = any(
                        kw.lower() in title.lower() for kw in meeting_keywords
                    ) or any(kw.lower() in app_name.lower() for kw in meeting_keywords)

                    if is_meeting:
                        is_idle = False
                    else:
                        is_idle = self.idle_detector.is_idle()

                    status = "Inactivo (Idle)" if is_idle else "Activo"
                    now_time = time.time()
                    elapsed = int(now_time - self.last_poll_time)
                    self.last_poll_time = now_time

                    print(
                        f"[{datetime.now().strftime('%H:%M:%S')}] {app_name} - {title[:30]}... ({status}) [{elapsed}s]"
                    )

                    self.db.log_activity(app_name, title, elapsed, is_idle)
                else:
                    print("No se pudo detectar ventana activa.")

                time.sleep(Config.POLL_INTERVAL)

        except KeyboardInterrupt:
            print("\nDeteniendo servicios...")
        finally:
            self.idle_detector.stop()
            print("Tracker finalizado.")

    def stop(self):
        self.running = False
        self.idle_detector.stop()
        print("Tracker finalizado.")
