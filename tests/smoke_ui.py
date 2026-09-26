"""Render every screen/state and exercise real QML controls.

Run from the repository root: QT_QPA_PLATFORM=offscreen .venv/bin/python tests/smoke_ui.py
Optional: --screenshots /absolute/existing/directory
"""
import argparse
import sys
import tempfile
from pathlib import Path

from PySide6.QtCore import QObject, QPoint, QSettings, QUrl, Qt, qInstallMessageHandler
from PySide6.QtGui import QGuiApplication, QImage, QColor, QFontDatabase
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtQuick import QQuickItem
from PySide6.QtQuickControls2 import QQuickStyle
from PySide6.QtTest import QTest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from backend.app_state import AppState
from backend.bridge import BackendBridge, CameraFrames


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--screenshots", type=Path)
    args = parser.parse_args()
    if args.screenshots and not args.screenshots.is_dir():
        parser.error("Screenshot directory must already exist")
    messages = []
    qInstallMessageHandler(lambda kind, context, text: messages.append(text))
    QQuickStyle.setStyle("Basic")
    app = QGuiApplication([])
    with tempfile.TemporaryDirectory() as directory:
        state = AppState(QSettings(str(Path(directory) / "test.ini"), QSettings.IniFormat))
        state._session_timer.stop()
        engine = QQmlApplicationEngine()
        frames = CameraFrames()
        bridge = BackendBridge(state, frames)
        engine.addImageProvider("camera", frames)
        engine.rootContext().setContextProperty("appState", state)
        families = QFontDatabase.families()
        font_family = next((name for name in ("Manrope", "Avenir Next", "Segoe UI", "DejaVu Sans") if name in families), app.font().family())
        engine.rootContext().setContextProperty("appFontFamily", font_family)
        engine.load(QUrl.fromLocalFile(str(ROOT / "qml/main.qml")))
        assert engine.rootObjects(), "Main window failed to load"
        window = engine.rootObjects()[0]
        rendered = 0

        def settle():
            QTest.qWait(120)

        def capture(name):
            nonlocal rendered
            settle()
            loader = window.findChild(QObject, "pageLoader")
            assert loader.property("item") is not None, f"Page failed: {name}"
            settings_loader = window.findChild(QObject, "settingsLoader")
            if settings_loader:
                assert settings_loader.property("item") is not None, f"Settings failed: {name}"
            image = window.grabWindow()
            assert not image.isNull(), f"No rendered frame: {name}"
            if args.screenshots:
                assert image.save(str(args.screenshots / f"{window.width()}-{name}.png"))
            rendered += 1

        def click(name):
            settle()
            def find(item):
                if item.objectName() == name:
                    return item
                for child in item.childItems():
                    match = find(child)
                    if match is not None:
                        return match
                return None
            item = find(window.contentItem())
            assert item is not None and item.isVisible(), f"Missing control: {name}"
            point = item.mapToScene(item.boundingRect().center())
            if point.y() > window.height() - 20:
                page = window.findChild(QObject, "pageLoader").property("item")
                page.setProperty("contentY", min(page.property("contentHeight") - page.height(),
                                                page.property("contentY") + point.y() - window.height() + 60))
                settle()
                point = item.mapToScene(item.boundingRect().center())
            assert 0 <= point.x() < window.width() and 0 <= point.y() < window.height(), f"Control outside window: {name} at {point}"
            QTest.mouseClick(window, Qt.LeftButton, Qt.NoModifier, QPoint(round(point.x()), round(point.y())))
            settle()

        for width, height in [(1440, 900), (1280, 720)]:
            window.resize(width, height)
            state.navigate("dashboard")
            capture("dashboard")
            click("nav-live")
            for index, posture in enumerate(["good", "forward", "left"]):
                click(f"demoPostureControl-option-{index}")
                assert state.postureKey == posture
                capture("live-" + posture)
            click("pauseMonitoringButton")
            assert state.monitoringState == "paused"
            capture("live-paused")
            click("pauseMonitoringButton")
            assert state.monitoringActive
            click("endMonitoringButton")
            assert state.monitoringState == "not_started"
            capture("live-ready")
            click("startMonitoringButton")
            assert state.monitoringActive
            state.navigate("statistics")
            for index, period in enumerate(["day", "week", "month"]):
                click(f"statisticsPeriodControl-option-{index}")
                assert state.statisticsPeriod == period
                capture("statistics-" + period)
            state.navigate("history")
            capture("history")
            click("viewSession-0")
            assert state.currentPage == "historyDetail"
            capture("history-detail")
            state.backToHistory()
            click("historySearch")
            for _ in range(5):
                QTest.keyClick(window, Qt.Key_Z)
            settle()
            assert not state.historySessions
            capture("history-empty")
            state.filterHistory("", 0, 0)
            state.navigate("settings")
            for category in ["camera", "notifications", "detection", "appearance", "profile"]:
                state.setSettingsCategory(category)
                capture("settings-" + category)
                if category == "camera":
                    previous = state.preferences["mirrorCamera"]
                    click("mirrorToggle")
                    assert state.preferences["mirrorCamera"] != previous
                    click("mirrorToggle")
                    assert state.preferences["mirrorCamera"] == previous
                    previous = state.skeletonVisible
                    click("skeletonToggle")
                    assert state.skeletonVisible != previous
                    click("skeletonToggle")
                    click("cameraSelect")
                    QTest.keyClick(window, Qt.Key_End)
                    QTest.keyClick(window, Qt.Key_Return)
                    settle()
                    assert state.preferences["cameraIndex"] == 1
                if category == "notifications":
                    previous = state.preferences["reminders"]
                    click("remindersToggle")
                    assert state.preferences["reminders"] != previous
                if category == "profile":
                    previous = state.preferences["profileName"]
                    click("profileNameInput")
                    QTest.keyClick(window, Qt.Key_X)
                    QTest.keyClick(window, Qt.Key_Return)
                    settle()
                    assert state.preferences["profileName"].count("x") == previous.count("x") + 1
            state.startCalibration()
            capture("calibration-camera")
            click("calibrationNext")
            capture("calibration-neutral")
            click("calibrationNext")
            capture("calibration-hold")
            QTest.qWait(3200)
            assert state.calibrationStep == 4
            capture("calibration-complete")
            state.finishCalibration()
            assert state.settingsCategory == "detection"
            state.navigate("live")
            state._advance_session(60)

        # A real frame can enter through the same UI boundary without a camera dependency.
        image = QImage(600, 330, QImage.Format_RGB32)
        image.fill(QColor("#C9B6F4"))
        bridge.push_frame(image)
        settle()
        assert state.cameraSource.startswith("image://camera/")
        capture("backend-frame")

        window.close()
        del engine
        app.processEvents()
        failures = [m for m in messages if any(s in m for s in (
            "file://", "Error", "failed", "Cannot", "Unable", "Binding loop", "invalid"))]
        if failures:
            raise AssertionError("\n".join(failures))
        print(f"PASS: {rendered} rendered screens/states at 1440×900 and 1280×720; controls, calibration, frame bridge; no QML errors.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
