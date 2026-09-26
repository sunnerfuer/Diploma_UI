# Backend integration contract

QML consumes `AppState` properties and invokes its UI commands. It never imports
MediaPipe or a classifier. `BackendBridge` accepts application-level results.

## Worker → UI

Construct the bridge on the GUI thread, as in `app.py`. Keep it alive for the
duration of the worker. The following methods may be called from a worker thread;
their signals use `Qt.QueuedConnection` to update state on the GUI thread.

```python
bridge.push_monitoring_state("active")
bridge.push_posture("forward", 89.0, "2026-09-26T14:20:00+03:00")
bridge.push_correction("forward", 18, "2026-09-26T14:20:18+03:00")
bridge.push_calibration_result(True, "Sep 26, 2026")
bridge.push_frame(qimage)
```

| Input | Contract |
|---|---|
| Posture | `good`, `forward`, `left`; unknown classes ignored |
| Confidence | Finite percentage, **0–100**, clamped; not a 0–1 probability |
| Timestamp | ISO 8601, optional; absent/invalid falls back to the current time |
| Monitoring | `not_started`, `active`, `paused`; invalid states ignored |
| Correction | `forward`/`left`, nonnegative duration in seconds, timestamp |
| Calibration | Success boolean and optional display date |
| Frame | Non-null `QImage`; copied at the boundary to isolate worker-owned memory |

Posture/correction inputs are ignored while paused or not started. A posture
update **does not automatically generate a correction**: the backend should apply
the configured persistence threshold before publishing `push_correction`.
The explicit demo switch generates its own marked demo correction for UI testing.

`active` starts a new session or resumes a paused one. `paused` stops active-time
accounting. `not_started` ends the session, snapshots it to History and clears
live counters. Repeated start/end commands are idempotent.

## Camera source

`CameraFrames`, registered as the `camera` image provider, stores the latest image.
Each incoming frame changes `appState.cameraSource` to a revisioned
`image://camera/<revision>` URL. `WebcamPreview.frameSource` consumes that URL
without knowing how the camera is acquired. No hardware is opened by the frontend.

The demo skeleton is a separate `SkeletonOverlay` and is hidden for backend frames.
For real pose rendering, supply an already composed frame or extend the overlay
with normalized, presentation-level points. Keep raw landmarks, model tensors and
debug values outside normal UI components. If composing an overlay in the backend,
observe the saved skeleton and mirror preferences to avoid double mirroring.

## UI → backend

`AppState.monitoringChanged` exposes Start/Pause/Resume/End intent through
`monitoringState`. `preferencesChanged` publishes a validated `preferences` map.
Connect these signals to the future worker/controller using queued connections.

Preference indexes:

- `cameraIndex`: 0 integrated demo, 1 external demo (replace with real device IDs).
- `reminderDelay`: `[5, 10, 15, 30]` seconds.
- `minimumDuration`: `[1, 3, 5]` seconds.
- `sensitivity`: 0–100; `stableDetection`, `reminders`, `sound`, `desktop`: booleans.
- `goalIndex`: `[1, 2, 3]` hours; `weekStart`: Monday/Sunday.

The current calibration timer is **only a frontend simulation**. When attaching
real calibration, replace `_tick_calibration`/timer start with a worker request,
then publish its result through the bridge. Cancel/back/navigation already stops
the simulation; connect those transitions to worker cancellation as well.

## Repositories

`mock_data.py` supplies analytics snapshots and date-relative history fixtures.
Replace those with a repository, retaining the `QVariantMap`/`QVariantList` field
names consumed by QML. Session IDs are stable strings, not filtered-list indexes.
Completed sessions are currently kept in memory; preferences use `QSettings`.
No model loading, training, inference or recording persistence is implemented.
