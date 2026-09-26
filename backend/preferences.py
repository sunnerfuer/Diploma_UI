"""Validated local preferences, independent of the lifetime of QML pages."""
import json

from PySide6.QtCore import QSettings


DEFAULTS = {
    "cameraIndex": 0, "mirrorCamera": True, "skeletonVisible": True,
    "reminders": True, "reminderDelay": 1, "sound": True, "desktop": True,
    "sensitivity": 70, "stableDetection": True, "minimumDuration": 1,
    "themeIndex": 0, "accentIndex": 0, "densityIndex": 0,
    "profileName": "Maria", "goalIndex": 1, "weekStart": 0,
    "lastCalibration": "Sep 10, 2026",
}
LIMITS = {
    "cameraIndex": 1, "reminderDelay": 3, "sensitivity": 100,
    "minimumDuration": 2, "themeIndex": 0, "accentIndex": 2,
    "densityIndex": 1, "goalIndex": 2, "weekStart": 1,
}


class Preferences:
    def __init__(self, store: QSettings | None = None):
        self.store = store if store is not None else QSettings("PostureFlow", "PostureFlow")
        self.values = dict(DEFAULTS)
        try:
            saved = json.loads(self.store.value("preferences", "{}"))
            if isinstance(saved, dict):
                for key, value in saved.items():
                    self.update(key, value, save=False)
        except (ValueError, TypeError):
            pass

    def update(self, key, value, *, save=True):
        if key not in DEFAULTS:
            return False
        if isinstance(DEFAULTS[key], bool):
            if not isinstance(value, bool):
                return False
        elif key in LIMITS:
            if not isinstance(value, (int, float)) or not 0 <= value <= LIMITS[key]:
                return False
            value = int(value)
        elif isinstance(value, str):
            value = value.strip()[:80]
            if not value:
                return False
        else:
            return False
        if self.values[key] == value:
            return False
        self.values[key] = value
        if save:
            self.store.setValue("preferences", json.dumps(self.values))
            self.store.sync()
        return True
