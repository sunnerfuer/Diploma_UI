from threading import Lock

from PySide6.QtCore import QObject, Signal, Slot, Qt
from PySide6.QtGui import QImage
from PySide6.QtQuick import QQuickImageProvider


class CameraFrames(QQuickImageProvider):
    """Latest-frame provider. No camera or model dependency in the UI."""
    def __init__(self):
        super().__init__(QQuickImageProvider.Image)
        self._image = QImage()
        self._lock = Lock()

    def update(self, image):
        with self._lock:
            self._image = image.copy()

    def requestImage(self, image_id, size, requested_size):
        with self._lock:
            image = self._image.copy()
        size.setWidth(image.width())
        size.setHeight(image.height())
        return image


class BackendBridge(QObject):
    """Thread-safe application-level input adapter; confidence is 0–100.

    Workers call push_*; queued signals mutate AppState only on the GUI thread.
    Timestamps are ISO 8601. Frames are copied before crossing the boundary.
    """
    postureReceived = Signal(str, float, str)
    monitoringReceived = Signal(str)
    correctionReceived = Signal(str, int, str)
    calibrationReceived = Signal(bool, str)
    frameReceived = Signal(QImage)

    def __init__(self, state, frames=None):
        super().__init__()
        self._state, self._frames, self._revision = state, frames, 0
        for signal, slot in (
            (self.postureReceived, state.applyBackendPosture),
            (self.monitoringReceived, state.applyBackendMonitoringState),
            (self.correctionReceived, state.applyBackendCorrection),
            (self.calibrationReceived, state.applyBackendCalibration),
            (self.frameReceived, self._apply_frame),
        ):
            signal.connect(slot, Qt.QueuedConnection)

    def push_posture(self, posture_key, confidence, timestamp=""):
        self.postureReceived.emit(posture_key, confidence, timestamp)

    def push_monitoring_state(self, state):
        self.monitoringReceived.emit(state)

    def push_correction(self, posture_key, duration_seconds, timestamp=""):
        self.correctionReceived.emit(posture_key, duration_seconds, timestamp)

    def push_calibration_result(self, ok, display_date=""):
        self.calibrationReceived.emit(ok, display_date)

    def push_frame(self, image):
        if not image.isNull():
            self.frameReceived.emit(image.copy())

    @Slot(QImage)
    def _apply_frame(self, image):
        if self._frames is not None:
            self._frames.update(image)
            self._revision += 1
            self._state.set_camera_source(f"image://camera/{self._revision}")
