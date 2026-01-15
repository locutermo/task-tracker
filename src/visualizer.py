import matplotlib.pyplot as plt
from datetime import datetime
from .database import DatabaseHandler


def format_duration(seconds):
    minutes, seconds = divmod(seconds, 60)
    hours, minutes = divmod(minutes, 60)
    if hours > 0:
        return f"{int(hours)}h {int(minutes)}m"
    return f"{int(minutes)}m"


def plot_daily_summary():
    db = DatabaseHandler()
    today = datetime.now().strftime("%Y-%m-%d")

    data = db.get_daily_summary(today, detailed=True)

    if not data:
        print(f"No hay actividad registrada para hoy ({today}).")
        return

    data = data[:20]
    formatted_labels = []
    minutes_list = []

    print(f"\n--- Detalle de Actividad ({today}) ---")
    print(f"{'Actividad':<60} | {'Tiempo':<10}")
    print("-" * 75)

    for row in data:
        app, title, seconds = row
        minutes = seconds / 60
        minutes_list.append(minutes)

        duration_str = format_duration(seconds)

        full_label = f"[{app}] {title}"
        truncated_label = (
            (full_label[:50] + "..") if len(full_label) > 50 else full_label
        )

        formatted_labels.append(truncated_label)
        print(f"{truncated_label:<60} | {duration_str:<10}")

    print("-" * 75)

    plt.figure(figsize=(12, len(data) * 0.4 + 2))
    bars = plt.barh(formatted_labels, minutes_list, color="cornflowerblue")

    plt.xlabel("Tiempo (minutos)")
    plt.title(f"Top Actividades - {today}")
    plt.gca().invert_yaxis()

    max_val = max(minutes_list) if minutes_list else 0
    for bar, seconds in zip(bars, [r[2] for r in data]):
        label = format_duration(seconds)
        width = bar.get_width()
        plt.text(
            width + (max_val * 0.01),
            bar.get_y() + bar.get_height() / 2,
            label,
            va="center",
            fontsize=9,
        )

    plt.tight_layout()
    plt.show()
