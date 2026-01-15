import time
from pynput import mouse, keyboard
from .config import Config


class IdleDetector:
    def __init__(self):
        self.last_activity = time.time()
        self.mouse_listener = mouse.Listener(
            on_move=self.on_activity,
            on_click=self.on_activity,
            on_scroll=self.on_activity,
        )
        self.keyboard_listener = keyboard.Listener(on_press=self.on_activity)
        self.running = False

    def on_activity(self, *args):
        self.last_activity = time.time()

    def start(self):
        try:
            self.running = True
            self.mouse_listener.start()
            self.keyboard_listener.start()
        except Exception as e:
            print(f"Error iniciando pynput: {e}")

    def stop(self):
        self.running = False
        self.mouse_listener.stop()
        self.keyboard_listener.stop()

    def is_idle(self):
        return (time.time() - self.last_activity) > Config.IDLE_TIMEOUT
