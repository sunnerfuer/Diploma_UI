"""Mock/demo data used by the PostureFlow frontend.

This file is deliberately backend-only.  Replace these structures with real
session/statistics repositories later; QML should continue to consume the same
AppState properties.
"""

from copy import deepcopy
from datetime import datetime, timedelta


DASHBOARD_SUMMARY = {
    "score": 84,
    "goodTime": "3h 42m",
    "goodPercent": 76,
    "corrections": 11,
    "focus": "Leaning forward",
    "focusMinutes": 38,
}

STATISTICS_SUMMARY = {
    "quality": 82,
    "goodTime": "6h 14m",
    "goodPercent": 76,
    "corrections": 24,
    "commonIssue": "Leaning forward",
    "commonIssueTime": "1h 24m",
    "consistencyDays": 5,
}

WEEKLY_QUALITY = [70, 72, 61, 60, 69, 75, 82]
WEEKLY_LABELS = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
CORRECTIONS_BY_DAY = [4, 6, 3, 2, 4, 3, 2]

POSTURE_DISTRIBUTION = [
    {"key": "good", "label": "Good posture", "value": 76},
    {"key": "forward", "label": "Leaning forward", "value": 17},
    {"key": "left", "label": "Leaning left", "value": 7},
]

RECENT_EVENTS = [
    {"time": "20:22", "key": "forward", "label": "Leaning forward", "detail": "14 sec"},
    {"time": "20:08", "key": "left", "label": "Leaning left", "detail": "8 sec"},
    {"time": "19:55", "key": "forward", "label": "Leaning forward", "detail": "21 sec"},
    {"time": "19:48", "key": "good", "label": "Session started", "detail": ""},
]

RECENT_EVENTS_BY_STATE = {
    "good": RECENT_EVENTS,
    "forward": [
        {"time": "20:24", "key": "forward", "label": "Leaning forward", "detail": "18 sec"},
        {"time": "20:22", "key": "forward", "label": "Leaning forward", "detail": "14 sec"},
        {"time": "20:08", "key": "left", "label": "Leaning left", "detail": "8 sec"},
        {"time": "19:48", "key": "good", "label": "Session started", "detail": ""},
    ],
    "left": [
        {"time": "20:26", "key": "left", "label": "Leaning left", "detail": "10 sec"},
        {"time": "20:08", "key": "left", "label": "Leaning left", "detail": "8 sec"},
        {"time": "19:55", "key": "forward", "label": "Leaning forward", "detail": "21 sec"},
        {"time": "19:48", "key": "good", "label": "Session started", "detail": ""},
    ],
}

HISTORY_SESSIONS = [
    {
        "date": "Sep 10, 2024", "time": "14:20", "duration": "1h 45m",
        "quality": 86, "issueKey": "forward", "issue": "Leaning forward",
        "alerts": 8, "end": "16:05", "good": 81, "forward": 14, "left": 5,
    },
    {
        "date": "Sep 9, 2024", "time": "18:10", "duration": "52m",
        "quality": 78, "issueKey": "left", "issue": "Leaning left",
        "alerts": 7, "end": "19:02", "good": 72, "forward": 12, "left": 16,
    },
    {
        "date": "Sep 8, 2024", "time": "09:30", "duration": "2h 05m",
        "quality": 88, "issueKey": "forward", "issue": "Leaning forward",
        "alerts": 6, "end": "11:35", "good": 84, "forward": 11, "left": 5,
    },
    {
        "date": "Sep 7, 2024", "time": "13:15", "duration": "1h 12m",
        "quality": 81, "issueKey": "good", "issue": "Good posture",
        "alerts": 5, "end": "14:27", "good": 83, "forward": 10, "left": 7,
    },
    {
        "date": "Sep 6, 2024", "time": "20:05", "duration": "47m",
        "quality": 74, "issueKey": "left", "issue": "Leaning left",
        "alerts": 9, "end": "20:52", "good": 69, "forward": 12, "left": 19,
    },
]


def make_history(now: datetime) -> list[dict]:
    """Date-relative fixtures keep the date filters useful on every launch."""
    sessions = deepcopy(HISTORY_SESSIONS)
    sessions.extend([deepcopy(sessions[1]), deepcopy(sessions[4])])
    for index, (session, days) in enumerate(zip(sessions, [0, 1, 2, 3, 4, 12, 35])):
        day = now - timedelta(days=days)
        session.update(id=f"demo-{index}", isoDate=day.date().isoformat(),
                       date=day.strftime("%b %d, %Y").replace(" 0", " "))
        start = datetime.combine(day.date(), datetime.strptime(session["time"], "%H:%M").time())
        end = datetime.combine(day.date(), datetime.strptime(session["end"], "%H:%M").time())
        duration = int((end - start).total_seconds())
        session["events"] = [
            {"time": (start + timedelta(seconds=int(duration * .78))).strftime("%H:%M"),
             "key": session["issueKey"], "label": session["issue"], "detail": "Corrected after 18 sec"},
            {"time": (start + timedelta(seconds=int(duration * .46))).strftime("%H:%M"),
             "key": "left", "label": "Leaning left", "detail": "Corrected after 9 sec"},
            {"time": session["time"], "key": "good", "label": "Session started", "detail": "Monitoring began"},
        ]
        session["markers"] = [{"p": .46, "key": "left"}, {"p": .78, "key": session["issueKey"]}]
    return sessions


STATISTICS_PERIODS = {
    "day": {
        "quality": 84, "goodTime": "3h 42m", "goodPercent": 76, "corrections": 11,
        "commonIssue": "Leaning forward", "commonIssueTime": "38 min", "periodLabel": "today",
        "qualityChange": "↑ 6% vs yesterday", "correctionsChange": "↓ 4 vs yesterday",
        "issueChange": "↓ 12% compared with yesterday", "consistency": "4 / 6", "unit": "hours",
        "consistencyText": "You maintained 75%+ neutral posture in four monitored hours today.",
        "values": [76, 81, 79, 84, 82, 86], "labels": ["09", "11", "13", "15", "17", "19"],
        "bars": [1, 3, 2, 1, 2, 2], "distribution": POSTURE_DISTRIBUTION,
    },
    "week": {
        **STATISTICS_SUMMARY, "periodLabel": "this week", "qualityChange": "↑ 7% vs last week",
        "correctionsChange": "↓ 12% vs last week", "issueChange": "↓ 18% compared with last week",
        "consistency": "5 / 7", "unit": "days",
        "consistencyText": "You maintained 75%+ neutral posture on five days this week.",
        "values": WEEKLY_QUALITY, "labels": WEEKLY_LABELS, "bars": CORRECTIONS_BY_DAY,
        "distribution": POSTURE_DISTRIBUTION,
    },
    "month": {
        "quality": 79, "goodTime": "28h 36m", "goodPercent": 73, "corrections": 108,
        "commonIssue": "Leaning forward", "commonIssueTime": "5h 12m", "periodLabel": "this month",
        "qualityChange": "↑ 5% vs last month", "correctionsChange": "↓ 9% vs last month",
        "issueChange": "↓ 14% compared with last month", "consistency": "21 / 30", "unit": "days",
        "consistencyText": "You maintained 75%+ neutral posture on 21 monitored days this month.",
        "values": [73, 76, 78, 82], "labels": ["W1", "W2", "W3", "W4"], "bars": [32, 28, 24, 24],
        "distribution": [{"key": "good", "label": "Good posture", "value": 73},
                         {"key": "forward", "label": "Leaning forward", "value": 19},
                         {"key": "left", "label": "Leaning left", "value": 8}],
    },
}
