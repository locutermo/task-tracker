import os
import sqlite3
from datetime import datetime
from src.config import Config


class DatabaseHandler:
    def __init__(self, db_name=Config.DB_NAME):
        self.db_name = db_name
        self.ensure_db_dir()
        self.init_db()
        self.migrate_old_data()

    def ensure_db_dir(self):
        db_dir = os.path.dirname(self.db_name)
        if not os.path.exists(db_dir):
            os.makedirs(db_dir)

    def migrate_old_data(self):
        # Si existe una DB en la carpeta actual, migrar los datos a la nueva ubicación global
        old_db = "timeline_abogados.db"
        if os.path.exists(old_db) and os.path.abspath(old_db) != os.path.abspath(
            self.db_name
        ):
            print(f"Migrando datos desde {old_db} a la ubicación unificada...")
            try:
                with sqlite3.connect(old_db) as conn_old:
                    cursor_old = conn_old.cursor()
                    cursor_old.execute(
                        "SELECT timestamp, app_name, window_title, duration, is_idle FROM activity_log"
                    )
                    rows = cursor_old.fetchall()

                    if rows:
                        with sqlite3.connect(self.db_name) as conn_new:
                            cursor_new = conn_new.cursor()
                            cursor_new.executemany(
                                "INSERT INTO activity_log (timestamp, app_name, window_title, duration, is_idle) VALUES (?, ?, ?, ?, ?)",
                                rows,
                            )
                            conn_new.commit()
                        print(f"✅ {len(rows)} registros migrados con éxito.")

                # Renombrar la vieja para que no se use más
                os.rename(old_db, old_db + ".backup")
            except Exception as e:
                print(f"Error durante la migración: {e}")

    def init_db(self):
        with sqlite3.connect(self.db_name) as conn:
            cursor = conn.cursor()
            cursor.execute("PRAGMA journal_mode=WAL")
            cursor.execute("""
                CREATE TABLE IF NOT EXISTS activity_log (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    timestamp DATETIME,
                    app_name TEXT,
                    window_title TEXT,
                    duration INTEGER,
                    is_idle BOOLEAN DEFAULT 0
                )
            """)

            cursor.execute("PRAGMA table_info(activity_log)")
            columns = [info[1] for info in cursor.fetchall()]
            if "is_idle" not in columns:
                cursor.execute(
                    "ALTER TABLE activity_log ADD COLUMN is_idle BOOLEAN DEFAULT 0"
                )

            conn.commit()

    def log_activity(self, app_name, window_title, duration, is_idle=False):
        now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        with sqlite3.connect(self.db_name) as conn:
            cursor = conn.cursor()
            cursor.execute(
                "INSERT INTO activity_log (timestamp, app_name, window_title, duration, is_idle) VALUES (?, ?, ?, ?, ?)",
                (now, app_name, window_title, duration, int(is_idle)),
            )
            conn.commit()

    def get_daily_summary(self, date_str, detailed=False):
        with sqlite3.connect(self.db_name) as conn:
            cursor = conn.cursor()
            if detailed:
                query = """
                    SELECT app_name, window_title, SUM(duration) as total_duration
                    FROM activity_log
                    WHERE timestamp LIKE ? AND is_idle = 0
                    GROUP BY app_name, window_title
                    ORDER BY total_duration DESC
                """
            else:
                query = """
                    SELECT app_name, SUM(duration) as total_duration
                    FROM activity_log
                    WHERE timestamp LIKE ? AND is_idle = 0
                    GROUP BY app_name
                    ORDER BY total_duration DESC
                """
            cursor.execute(query, (f"{date_str}%",))
            return cursor.fetchall()

    def clear_history(self):
        with sqlite3.connect(self.db_name) as conn:
            cursor = conn.cursor()
            cursor.execute("DELETE FROM activity_log")
            conn.commit()
            print("Base de datos limpiada correctamente.")

    def export_logs(self, filename="activity_history.log"):
        with sqlite3.connect(self.db_name) as conn:
            cursor = conn.cursor()
            cursor.execute(
                "SELECT timestamp, app_name, window_title, duration FROM activity_log WHERE is_idle = 0 ORDER BY timestamp ASC"
            )
            rows = cursor.fetchall()
            history = {}
            for timestamp, app, title, duration in rows:
                date_part = timestamp.split(" ")[0]
                if date_part not in history:
                    history[date_part] = {}

                key = (app, title)
                history[date_part][key] = history[date_part].get(key, 0) + duration

            total_records = len(rows)

            with open(filename, "w", encoding="utf-8") as f:
                f.write("=== HISTORIAL DETALLADO (AGRUPADO) ===\n")

                sorted_dates = sorted(history.keys())

                for date_str in sorted_dates:
                    daily_data = history[date_str]
                    sorted_activities = sorted(
                        daily_data.items(), key=lambda x: x[1], reverse=True
                    )

                    f.write(f"\n--- Detalle de Actividad ({date_str}) ---\n")
                    f.write(
                        f"{'Aplicación':<25} | {'Actividad':<60} | {'Tiempo':<10}\n"
                    )
                    f.write("-" * 100 + "\n")

                    for (app, title), seconds in sorted_activities:
                        if seconds < 60:
                            duration_str = f"{int(seconds)}s"
                        else:
                            minutes = int(seconds // 60)
                            duration_str = f"{minutes}m"

                        app_label = (app[:22] + "..") if len(app) > 22 else app
                        title_label = (title[:57] + "..") if len(title) > 57 else title

                        f.write(
                            f"{app_label:<25} | {title_label:<60} | {duration_str:<10}\n"
                        )
                    f.write("-" * 100 + "\n")

            return total_records
