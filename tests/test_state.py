import tempfile
import threading
import unittest
from pathlib import Path

from PySide6.QtCore import QCoreApplication, QSettings

from backend.app_state import AppState
from backend.bridge import BackendBridge


class StateTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.app = QCoreApplication.instance() or QCoreApplication([])

    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.settings = QSettings(str(Path(self.directory.name) / "test.ini"), QSettings.IniFormat)
        self.state = AppState(self.settings, demo=False)
        self.state._session_timer.stop()

    def tearDown(self):
        self.state._calibration_timer.stop()
        self.state.deleteLater()
        self.directory.cleanup()

    def test_session_lifecycle_retains_history_and_resets_counters(self):
        self.state.startMonitoring()
        self.state._advance_session(60)
        self.state.setPostureState("forward")
        self.state._advance_session(20)
        self.state.pauseMonitoring()
        self.state.setPostureState("left")
        self.assertEqual(self.state.postureKey, "forward")
        self.assertEqual(self.state.elapsedText, "00:01:20")
        self.state.resumeMonitoring()
        self.state.setPostureState("good")
        self.state._advance_session(20)
        self.assertEqual(self.state.correctionCount, 1)
        self.assertEqual(sum(row["value"] for row in self.state.sessionDistribution), 100)
        self.state.endMonitoring()
        session = self.state.historySessions[0]
        self.assertEqual(session["quality"], 80)
        self.assertEqual(session["duration"], "00:01:40")
        self.assertEqual(session["alerts"], 1)
        self.assertEqual(self.state.elapsedText, "00:00:00")
        self.assertEqual(self.state.goodMinutes, 0)
        self.assertEqual(self.state.correctionCount, 0)
        self.state.startMonitoring()
        self.assertEqual(self.state.correctionCount, 0)
        self.state.openSession(session["id"])
        self.assertEqual(self.state.selectedSession["quality"], 80)

    def test_preferences_survive_page_changes_and_reload(self):
        self.state.setPreference("mirrorCamera", False)
        self.state.setPreference("profileName", "  Alex  ")
        self.state.setPreference("sensitivity", 45)
        self.state.navigate("settings")
        self.state.setSettingsCategory("profile")
        self.state.navigate("live")
        other = AppState(self.settings, demo=False)
        self.assertFalse(other.preferences["mirrorCamera"])
        self.assertEqual(other.preferences["profileName"], "Alex")
        self.assertEqual(other.preferences["sensitivity"], 45)
        other.setPreference("profileName", " ")
        other.setPreference("sensitivity", 300)
        self.assertEqual(other.preferences["profileName"], "Alex")
        self.assertEqual(other.preferences["sensitivity"], 45)
        other._session_timer.stop()
        other.deleteLater()

    def test_history_filters_and_stable_selection(self):
        self.state.filterHistory("", 0, 3)
        self.assertEqual(len(self.state.historySessions), 7)
        self.state.filterHistory("", 0, 1)
        self.assertEqual(len(self.state.historySessions), 5)
        self.state.filterHistory("left", 3, 0)
        self.assertTrue(self.state.historySessions)
        selected = self.state.historySessions[-1]
        self.state.openSession(selected["id"])
        self.assertEqual(self.state.selectedSession, selected)
        self.state.filterHistory("missing session", 0, 3)
        self.assertEqual(self.state.historySessions, [])

    def test_calibration_cancel_stops_background_completion(self):
        self.state.startCalibration()
        self.state.nextCalibration()
        self.state.nextCalibration()
        self.assertTrue(self.state._calibration_timer.isActive())
        self.state.setSettingsCategory("camera")
        self.state._tick_calibration()
        self.assertFalse(self.state._calibration_timer.isActive())
        self.assertFalse(self.state.calibrationActive)
        self.assertEqual(self.state.calibrationStep, 1)

    def test_calibration_completion_and_monitoring(self):
        self.state.startCalibration()
        self.state.nextCalibration()
        self.state.nextCalibration()
        for _ in range(3):
            self.state._tick_calibration()
        self.assertEqual(self.state.calibrationStep, 4)
        self.assertEqual(self.state.calibrationProgress, 1)
        self.state.finishCalibrationAndMonitor()
        self.assertEqual(self.state.currentPage, "live")
        self.assertTrue(self.state.monitoringActive)

    def test_statistics_switches_entire_snapshot(self):
        for period, total in [("day", 11), ("week", 24), ("month", 108)]:
            self.state.setStatisticsPeriod(period)
            stats = self.state.statisticsSummary
            self.assertEqual(stats["corrections"], total)
            self.assertEqual(sum(stats["bars"]), total)
            self.assertEqual(len(stats["values"]), len(stats["labels"]))
            self.assertEqual(sum(row["value"] for row in stats["distribution"]), 100)

    def test_worker_bridge_is_queued_and_validates_posture(self):
        self.state.startMonitoring()
        bridge = BackendBridge(self.state)
        worker = threading.Thread(target=lambda: (
            bridge.push_posture("left", 91, "2026-09-26T12:00:00"),
            bridge.push_correction("left", 9, "2026-09-26T12:00:09"),
        ))
        worker.start()
        worker.join()
        self.assertEqual(self.state.postureKey, "good")
        self.app.processEvents()
        self.assertEqual(self.state.postureKey, "left")
        self.assertEqual(self.state.correctionCount, 1)
        self.assertEqual(self.state.recentEvents[0]["time"], "12:00")
        self.state.applyBackendPosture("unknown", 50)
        self.state.applyBackendPosture("good", float("nan"))
        self.assertEqual(self.state.postureKey, "left")


if __name__ == "__main__":
    unittest.main()
