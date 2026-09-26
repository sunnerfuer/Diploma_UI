from __future__ import annotations

from copy import deepcopy
from datetime import datetime, timedelta
import math
from uuid import uuid4

from PySide6.QtCore import QObject, Property, Signal, Slot, QTimer, QElapsedTimer

from .mock_data import DASHBOARD_SUMMARY, POSTURE_DISTRIBUTION, STATISTICS_PERIODS, make_history
from .preferences import Preferences


POSTURES = {
    "good": ("Good posture", "Your position looks balanced.",
             "You're sitting well. Keep your shoulders relaxed and continue working normally."),
    "forward": ("Leaning forward", "Try moving your upper body slightly back.",
                "Move your upper body slightly back and keep your neck relaxed."),
    "left": ("Leaning left", "Try bringing your shoulders back toward the center.",
             "Bring your shoulders gently back toward the center. Keep your torso balanced."),
}


class AppState(QObject):
    """GUI-thread state. The bridge queues backend updates onto this thread."""

    currentPageChanged = Signal()
    postureChanged = Signal()
    monitoringChanged = Signal()
    sessionChanged = Signal()
    skeletonChanged = Signal()
    recentEventsChanged = Signal()
    historyChanged = Signal()
    selectedSessionChanged = Signal()
    settingsCategoryChanged = Signal()
    calibrationChanged = Signal()
    preferencesChanged = Signal()
    statisticsChanged = Signal()
    cameraChanged = Signal()

    def __init__(self, settings=None, *, demo=True):
        super().__init__()
        self._preferences = Preferences(settings)
        self._current_page = "dashboard"
        self._posture_key, self._confidence = "good", 92
        self._monitoring_state = "active" if demo else "not_started"
        self._elapsed_seconds = 2536 if demo else 0
        self._posture_seconds = {"good": 1860, "forward": 460, "left": 216} if demo else dict.fromkeys(POSTURES, 0)
        self._correction_count = 6 if demo else 0
        self._session_start = datetime.now() - timedelta(seconds=self._elapsed_seconds)
        self._session_end = datetime.now()
        self._events = []
        self._markers = []
        if demo:
            for offset, key in [(420, "forward"), (1200, "left"), (2100, "forward")]:
                self._events.insert(0, self._event(key, "Correction recorded", self._session_start + timedelta(seconds=offset)))
                self._markers.append({"second": offset, "key": key})
        self._history = make_history(datetime.now())
        self._selected_session = deepcopy(self._history[0])
        self._history_search, self._history_issue, self._history_range = "", 0, 0
        self._period = "week"
        self._settings_category = "camera"
        self._calibration_active = False
        self._calibration_step, self._calibration_countdown = 1, 3
        self._calibration_progress = 0.0
        self._calibrated = True
        self._camera_source = ""
        self._clock = QElapsedTimer()
        self._clock.start()
        self._session_timer = QTimer(self)
        self._session_timer.setInterval(250)
        self._session_timer.timeout.connect(self._tick_session)
        self._session_timer.start()
        self._calibration_timer = QTimer(self)
        self._calibration_timer.setInterval(1000)
        self._calibration_timer.timeout.connect(self._tick_calibration)

    @Property(str, notify=currentPageChanged)
    def currentPage(self):
        return self._current_page

    @Slot(str)
    def navigate(self, page):
        if page not in ("dashboard", "live", "statistics", "history", "historyDetail", "settings") or page == self._current_page:
            return
        if page != "settings" and self._calibration_active:
            self.cancelCalibration()
        self._current_page = page
        self.currentPageChanged.emit()

    @Property(str, notify=postureChanged)
    def postureKey(self):
        return self._posture_key

    @Property(str, notify=postureChanged)
    def postureLabel(self):
        return POSTURES[self._posture_key][0].upper()

    @Property(str, notify=postureChanged)
    def postureMessage(self):
        return POSTURES[self._posture_key][1]

    @Property(str, notify=postureChanged)
    def postureTip(self):
        return POSTURES[self._posture_key][2]

    @Property(int, notify=postureChanged)
    def confidence(self):
        return self._confidence

    @Slot(str, float, str)
    def applyBackendPosture(self, key, confidence, timestamp=""):
        if key not in POSTURES or not math.isfinite(confidence) or not self.monitoringActive:
            return
        self._tick_session()
        changed = key != self._posture_key
        self._posture_key = key
        self._confidence = max(0, min(100, round(confidence)))
        if changed:
            self._events.insert(0, self._event(key, "Posture changed", self._parse_time(timestamp)))
            self._markers.append({"second": self._elapsed_seconds, "key": key})
            self.recentEventsChanged.emit()
            self.sessionChanged.emit()
        self.postureChanged.emit()

    @Slot(str)
    def setPostureState(self, key):
        if key in POSTURES:
            changed = key != self._posture_key
            self.applyBackendPosture(key, {"good": 92, "forward": 89, "left": 91}[key])
            if changed and key != "good" and self.monitoringActive:
                self.applyBackendCorrection(key, 0, "")

    @Slot(str, int, str)
    def applyBackendCorrection(self, key, duration, timestamp):
        if not self.monitoringActive or key not in ("forward", "left") or duration < 0:
            return
        self._correction_count += 1
        detail = f"Corrected after {duration} sec" if duration else "Demo correction"
        self._events.insert(0, self._event(key, detail, self._parse_time(timestamp)))
        self.recentEventsChanged.emit()
        self.sessionChanged.emit()

    @staticmethod
    def _parse_time(value):
        try:
            return datetime.fromisoformat(value) if value else datetime.now()
        except (ValueError, TypeError):
            return datetime.now()

    @staticmethod
    def _event(key, detail, when):
        return {"time": when.strftime("%H:%M"), "timestamp": when.isoformat(),
                "key": key, "label": POSTURES[key][0], "detail": detail}

    @Property(str, notify=monitoringChanged)
    def monitoringState(self):
        return self._monitoring_state

    @Property(bool, notify=monitoringChanged)
    def monitoringActive(self):
        return self._monitoring_state == "active"

    @Slot(str)
    def applyBackendMonitoringState(self, state):
        if state == "active":
            self.resumeMonitoring() if self._monitoring_state == "paused" else self.startMonitoring()
        elif state == "paused":
            self.pauseMonitoring()
        elif state == "not_started":
            self.endMonitoring()

    @Slot()
    def startMonitoring(self):
        if self._monitoring_state != "not_started":
            return
        self._elapsed_seconds, self._correction_count = 0, 0
        self._posture_seconds = dict.fromkeys(POSTURES, 0)
        self._posture_key, self._confidence = "good", 92
        self._session_start = datetime.now()
        self._session_end = self._session_start
        self._events = [{"time": self._session_start.strftime("%H:%M"), "key": "good",
                         "label": "Session started", "detail": "Monitoring began"}]
        self._markers = []
        self._monitoring_state = "active"
        self._clock.restart()
        self.monitoringChanged.emit()
        self.sessionChanged.emit()
        self.postureChanged.emit()
        self.recentEventsChanged.emit()

    @Slot()
    def pauseMonitoring(self):
        if self.monitoringActive:
            self._tick_session()
            self._monitoring_state = "paused"
            self.monitoringChanged.emit()

    @Slot()
    def resumeMonitoring(self):
        if self._monitoring_state == "paused":
            self._clock.restart()
            self._monitoring_state = "active"
            self.monitoringChanged.emit()

    @Slot()
    def endMonitoring(self):
        if self._monitoring_state == "not_started":
            return
        self._tick_session()
        if self._elapsed_seconds:
            distribution = {row["key"]: row["value"] for row in self.sessionDistribution}
            issue = max(("forward", "left"), key=lambda key: self._posture_seconds[key])
            if not self._correction_count:
                issue = "good"
            self._history.insert(0, {
                "id": str(uuid4()), "date": self._session_start.strftime("%b %d, %Y"),
                "isoDate": self._session_start.date().isoformat(), "time": self.sessionStarted,
                "end": datetime.now().strftime("%H:%M"), "duration": self.elapsedText,
                "quality": distribution["good"], "alerts": self._correction_count,
                "issueKey": issue, "issue": POSTURES[issue][0], **distribution,
                "events": deepcopy(self._events), "markers": self.sessionMarkers,
            })
            self.historyChanged.emit()
        self._monitoring_state = "not_started"
        self._elapsed_seconds, self._correction_count = 0, 0
        self._posture_seconds = dict.fromkeys(POSTURES, 0)
        self._events, self._markers = [], []
        self.monitoringChanged.emit()
        self.sessionChanged.emit()
        self.recentEventsChanged.emit()

    @Property(str, notify=sessionChanged)
    def elapsedText(self):
        hours, rest = divmod(self._elapsed_seconds, 3600)
        minutes, seconds = divmod(rest, 60)
        return f"{hours:02d}:{minutes:02d}:{seconds:02d}"

    @Property(int, notify=sessionChanged)
    def elapsedMinutes(self):
        return self._elapsed_seconds // 60

    @Property(str, notify=sessionChanged)
    def sessionStarted(self):
        return self._session_start.strftime("%H:%M")

    @Property(str, notify=sessionChanged)
    def sessionEnd(self):
        return self._session_end.strftime("%H:%M")

    @Property(int, notify=sessionChanged)
    def goodMinutes(self):
        return self._posture_seconds["good"] // 60

    @Property(int, notify=sessionChanged)
    def correctionCount(self):
        return self._correction_count

    def _tick_session(self):
        if not self.monitoringActive:
            return
        seconds = self._clock.elapsed() // 1000
        if seconds:
            self._clock.restart()
            self._advance_session(seconds)

    def _advance_session(self, seconds):
        self._session_end = datetime.now()
        self._elapsed_seconds += seconds
        self._posture_seconds[self._posture_key] += seconds
        self.sessionChanged.emit()

    @Property("QVariantList", notify=sessionChanged)
    def sessionDistribution(self):
        total = sum(self._posture_seconds.values())
        values = [round(self._posture_seconds[k] / total * 100) if total else 0 for k in POSTURES]
        if total:
            values[values.index(max(values))] += 100 - sum(values)
        return [{"key": k, "label": POSTURES[k][0], "value": v} for k, v in zip(POSTURES, values)]

    @Property("QVariantList", notify=sessionChanged)
    def sessionMarkers(self):
        return [{"p": min(1, m["second"] / max(1, self._elapsed_seconds)), "key": m["key"]} for m in self._markers]

    @Property("QVariantList", notify=recentEventsChanged)
    def recentEvents(self):
        return self._events[:4]

    @Property("QVariantMap", constant=True)
    def dashboardSummary(self):
        return DASHBOARD_SUMMARY

    @Property("QVariantList", constant=True)
    def postureDistribution(self):
        return POSTURE_DISTRIBUTION

    @Property("QVariantList", constant=True)
    def weeklyQuality(self):
        return STATISTICS_PERIODS["week"]["values"]

    @Property("QVariantList", constant=True)
    def weeklyLabels(self):
        return STATISTICS_PERIODS["week"]["labels"]

    @Property(str, notify=statisticsChanged)
    def statisticsPeriod(self):
        return self._period

    @Property("QVariantMap", notify=statisticsChanged)
    def statisticsSummary(self):
        result = dict(STATISTICS_PERIODS[self._period])
        today = datetime.now()
        result["dateRange"] = today.strftime("%b %d, %Y") if self._period == "day" else (
            today.strftime("%B %Y") if self._period == "month" else
            f"{(today - timedelta(days=today.weekday())).strftime('%b %d')} – {(today + timedelta(days=6-today.weekday())).strftime('%b %d, %Y')}")
        return result

    @Slot(str, result="QVariantMap")
    def statisticsSnapshot(self, period):
        return deepcopy(STATISTICS_PERIODS.get(period, STATISTICS_PERIODS["week"]))

    @Slot(str)
    def setStatisticsPeriod(self, period):
        if period in STATISTICS_PERIODS:
            self._period = period
            self.statisticsChanged.emit()

    @Property("QVariantList", notify=historyChanged)
    def historySessions(self):
        today = datetime.now().date()
        result = []
        for session in self._history:
            day = datetime.fromisoformat(session["isoDate"]).date()
            if self._history_range == 0 and not 0 <= (today - day).days < 30:
                continue
            if self._history_range == 1 and not 0 <= (today - day).days < 7:
                continue
            if self._history_range == 2 and (day.year, day.month) != (today.year, today.month):
                continue
            if self._history_issue and session["issueKey"] != ["", "good", "forward", "left"][self._history_issue]:
                continue
            if self._history_search not in f"{session['date']} {session['time']} {session['issue']}".casefold():
                continue
            result.append(session)
        return result

    @Property("QVariantMap", notify=historyChanged)
    def historyFilters(self):
        return {"search": self._history_search, "issue": self._history_issue, "range": self._history_range}

    @Slot(str, int, int)
    def filterHistory(self, search, issue, date_range):
        if issue not in range(4) or date_range not in range(4):
            return
        self._history_search, self._history_issue, self._history_range = search.casefold().strip(), issue, date_range
        self.historyChanged.emit()

    @Property("QVariantMap", notify=selectedSessionChanged)
    def selectedSession(self):
        return self._selected_session

    @Slot(str)
    def openSession(self, session_id):
        for session in self._history:
            if session["id"] == session_id:
                self._selected_session = deepcopy(session)
                self.selectedSessionChanged.emit()
                self.navigate("historyDetail")
                break

    @Slot()
    def backToHistory(self):
        self.navigate("history")

    @Property("QVariantMap", notify=preferencesChanged)
    def preferences(self):
        return dict(self._preferences.values)

    @Slot(str, "QVariant")
    def setPreference(self, key, value):
        if self._preferences.update(key, value):
            self.preferencesChanged.emit()
            if key == "skeletonVisible":
                self.skeletonChanged.emit()

    @Property(bool, notify=skeletonChanged)
    def skeletonVisible(self):
        return self._preferences.values["skeletonVisible"]

    @Slot(bool)
    def setSkeletonVisible(self, value):
        self.setPreference("skeletonVisible", value)

    @Property(str, notify=cameraChanged)
    def cameraSource(self):
        return self._camera_source

    def set_camera_source(self, source):
        self._camera_source = source
        self.cameraChanged.emit()

    @Property(str, notify=settingsCategoryChanged)
    def settingsCategory(self):
        return self._settings_category

    @Slot(str)
    def setSettingsCategory(self, category):
        if category in ("camera", "notifications", "detection", "appearance", "profile"):
            self.cancelCalibration()
            self._settings_category = category
            self.settingsCategoryChanged.emit()

    @Property(bool, notify=calibrationChanged)
    def calibrationActive(self):
        return self._calibration_active

    @Property(int, notify=calibrationChanged)
    def calibrationStep(self):
        return self._calibration_step

    @Property(int, notify=calibrationChanged)
    def calibrationCountdown(self):
        return self._calibration_countdown

    @Property(float, notify=calibrationChanged)
    def calibrationProgress(self):
        return self._calibration_progress

    @Property(bool, notify=calibrationChanged)
    def calibrated(self):
        return self._calibrated

    @Property(str, notify=calibrationChanged)
    def lastCalibration(self):
        return self._preferences.values["lastCalibration"]

    @Slot(bool, str)
    def applyBackendCalibration(self, ok, display_date):
        self._calibration_timer.stop()
        self._calibrated = ok
        if ok:
            self.setPreference("lastCalibration", display_date or datetime.now().strftime("%b %d, %Y"))
            if self._calibration_active:
                self._calibration_step, self._calibration_progress, self._calibration_countdown = 4, 1.0, 0
        else:
            self._calibration_step, self._calibration_progress = 1, 0.0
        self.calibrationChanged.emit()

    @Slot()
    def startCalibration(self):
        self._calibration_timer.stop()
        self.navigate("settings")
        self._settings_category = "detection"
        self._calibration_active = True
        self._calibration_step, self._calibration_countdown, self._calibration_progress = 1, 3, 0.0
        self.settingsCategoryChanged.emit()
        self.calibrationChanged.emit()

    @Slot()
    def nextCalibration(self):
        if not self._calibration_active:
            return
        if self._calibration_step == 1:
            self._calibration_step = 2
        elif self._calibration_step == 2:
            self._calibration_step, self._calibration_countdown, self._calibration_progress = 3, 3, 0.0
            self._calibration_timer.start()
        self.calibrationChanged.emit()

    @Slot()
    def previousCalibration(self):
        if self._calibration_active and 1 < self._calibration_step < 4:
            self._calibration_timer.stop()
            self._calibration_step -= 1
            self._calibration_countdown, self._calibration_progress = 3, 0.0
            self.calibrationChanged.emit()

    @Slot()
    def cancelCalibration(self):
        self._calibration_timer.stop()
        self._calibration_active = False
        self._calibration_step = 1
        self.calibrationChanged.emit()

    @Slot()
    def finishCalibration(self):
        if self._calibration_step == 4:
            self.setSettingsCategory("detection")

    @Slot()
    def finishCalibrationAndMonitor(self):
        if self._calibration_step != 4:
            return
        self.finishCalibration()
        if self._monitoring_state == "paused":
            self.resumeMonitoring()
        else:
            self.startMonitoring()
        self.navigate("live")

    def _tick_calibration(self):
        if not self._calibration_active or self._calibration_step != 3:
            self._calibration_timer.stop()
            return
        self._calibration_countdown -= 1
        self._calibration_progress = (3 - self._calibration_countdown) / 3
        if self._calibration_countdown <= 0:
            self.applyBackendCalibration(True, datetime.now().strftime("%b %d, %Y"))
        else:
            self.calibrationChanged.emit()
