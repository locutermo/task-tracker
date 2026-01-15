import os


class Config:
    DB_NAME = os.path.expanduser("~/.tracker/timeline_abogados.db")
    POLL_INTERVAL = 5
    IDLE_TIMEOUT = 300
