#!/usr/bin/env python3
import argparse
from .database import DatabaseHandler
from .tracker import ActivityTracker
from .visualizer import plot_daily_summary


def main():
    parser = argparse.ArgumentParser(
        description="Tracker de actividad legal con detección de inactividad"
    )
    parser.add_argument(
        "--plot", action="store_true", help="Mostrar gráfico de actividad del día"
    )
    parser.add_argument(
        "--clear",
        action="store_true",
        help="Limpiar todo el historial de la base de datos",
    )
    parser.add_argument(
        "--export",
        type=str,
        nargs="?",
        const="activity_history.log",
        help="Exportar historial a archivo .log (por defecto: activity_history.log)",
    )
    args = parser.parse_args()

    if args.export:
        db = DatabaseHandler()
        count = db.export_logs(args.export)
        print(
            f"Exportación completada. {count} registros guardados en '{args.export}'."
        )
        return

    if args.clear:
        db = DatabaseHandler()
        db.clear_history()
        return

    if args.plot:
        plot_daily_summary()
    else:
        tracker = ActivityTracker()
        tracker.start()


if __name__ == "__main__":
    main()
