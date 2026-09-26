import sys
from pathlib import Path

from PySide6.QtCore import QUrl, QCoreApplication, QEvent
from PySide6.QtGui import QGuiApplication, QFontDatabase
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtQuickControls2 import QQuickStyle

if __package__:
    from .backend import AppState, BackendBridge
    from .backend.bridge import CameraFrames
else:
    from backend import AppState, BackendBridge
    from backend.bridge import CameraFrames


def main() -> int:
    QQuickStyle.setStyle("Basic")
    app = QGuiApplication(sys.argv)
    app.setApplicationName("PostureFlow")
    app.setOrganizationName("PostureFlow")

    root = Path(__file__).resolve().parent
    qml_file = root / "qml" / "main.qml"

    state = AppState()
    frames = CameraFrames()
    bridge = BackendBridge(state, frames)
    app._postureflow_bridge = bridge  # keep the future backend adapter alive
    engine = QQmlApplicationEngine()
    engine.addImageProvider("camera", frames)
    families = QFontDatabase.families()
    font_family = next((name for name in ("Manrope", "Avenir Next", "Segoe UI", "DejaVu Sans") if name in families), app.font().family())
    engine.rootContext().setContextProperty("appFontFamily", font_family)
    engine.rootContext().setContextProperty("appState", state)
    engine.addImportPath(str(root / "qml"))
    engine.load(QUrl.fromLocalFile(str(qml_file)))

    if not engine.rootObjects():
        return 1
    result = app.exec()
    # Destroy QML objects while their context properties still exist.
    engine.deleteLater()
    QCoreApplication.sendPostedEvents(None, QEvent.DeferredDelete)
    return result


if __name__ == "__main__":
    raise SystemExit(main())
