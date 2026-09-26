# PostureFlow

Desktop frontend дипломного приложения для мониторинга осанки.
**Python 3.10+ · PySide6 6.7+ · Qt Quick / QML.**

## Запуск

Команды ниже выполняются из корня репозитория.

### macOS / Linux

```bash
python3 -m venv .venv
.venv/bin/python -m pip install -r requirements.txt
sh run.sh
```

### Windows

Для Windows 10/11 используйте 64-битный Python (например, 3.12).
Виртуальное окружение создаётся на самой Windows; переносить `.venv` с macOS не нужно.

```powershell
py -m venv .venv
.venv\Scripts\python.exe -m pip install -r requirements.txt
.\run_windows.bat
```

Скрипты запуска находят приложение и `.venv` относительно своего расположения,
поэтому их можно вызывать из другой директории. Альтернатива — `python app.py`
в активированном окружении.

Проект также собирается в Python wheel вместе с QML и изображениями:

```bash
python -m pip install .
postureflow
```

На Linux для обычного оконного запуска требуется графическая сессия и системные
библиотеки Qt/X11 либо Wayland. Для автоматических проверок есть offscreen-режим.

## Экраны и взаимодействия

- **Dashboard:** показатели дня, текущая сессия, Week/Month trend, фокус дня,
  распределение и последние события. Open ведёт на Live, View details — в Statistics.
- **Live Monitoring:** большая камера, skeleton/mirror, три семантических состояния,
  confidence, таймер, хорошее время, коррекции, подсказка, события и timeline.
  Start → Pause → Resume → End. Пауза останавливает учёт времени и обновления осанки.
  End сохраняет результат в History и сбрасывает счётчики новой сессии.
- **Statistics:** Day / Week / Month меняет весь демо-снимок: KPI, графики,
  распределение, common issue, consistency и период. Линия показывает значение при наведении.
- **History:** поиск по дате/времени/осанке, фильтр основной проблемы, последние
  7/30 дней, текущий месяц либо все даты. View открывает именно выбранную сессию,
  включая её события, timeline, распределение и summary. Есть пустое состояние.
- **Settings:** Camera, Notifications, Detection, Appearance, Profile.
  Значения сохраняются через `QSettings`, включая имя, зеркало, skeleton,
  параметры уведомлений и детекции. Имя отображается в sidebar.
  Accent применяется к элементам управления; семантические цвета осанки постоянны.
  Comfortable/Compact меняет внешние отступы. Light доступна; Dark/System явно отключены.
- **Calibration:** Camera check → Neutral posture → Hold still (3 секунды) → Complete.
  Дата сохраняется. Done возвращает в Detection; Start monitoring открывает Live.
  Cancel, Back и уход со страницы корректно останавливают таймер.

### Демо-управление

Приложение стартует с активной примерной сессией **00:42:16**, чтобы сразу показать
наполненный экран. Для проверки чистого старта нажмите End session, затем Start monitoring.

На Live есть переключатель состояний и горячие клавиши:

| Клавиша | Действие |
|---|---|
| `1` | Good posture — lime |
| `2` | Leaning forward — peach |
| `3` | Leaning left — lilac |
| `Space` | Start / Pause / Resume |

Горячие клавиши действуют только на Live. Переключение на проблемную осанку
добавляет демонстрационную коррекцию; повторный выбор того же состояния её не дублирует.

### Границы демо

Камера показывает приложенные фотографии с маркировкой DEMO; выбор устройства
сохраняет предпочтение, но не открывает оборудование. Calibration моделирует
сохранение baseline; реального ML-baseline в этой версии нет. Notification и
Detection settings сохраняют конфигурацию будущего backend, но не запускают
системные уведомления, звук или классификатор.

Dashboard и Statistics используют фиксированные демонстрационные снимки,
а текущая сессия, таймер, события и новые записи History обновляются в памяти.
История пересоздаётся при запуске; её демонстрационные даты привязаны к текущему дню,
чтобы фильтры работали. Настройки и дата калибровки переживают перезапуск.

## Структура

```text
app.py                    # запуск Qt, шрифт, QML context, image provider
backend/
  app_state.py            # состояние, команды, сессии, история, калибровка
  bridge.py               # queued input adapter + camera image provider
  preferences.py          # валидация и локальное хранение настроек
  mock_data.py            # демонстрационные снимки и история
qml/
  main.qml                # оболочка, навигация, scoped shortcuts
  theme/                  # цвета, типографика, геометрия, семантика
  components/             # карточки, графики, camera, skeleton, controls
  pages/                  # основные страницы и детали сессии
  settings/               # разделы настроек и calibration flow
assets/                   # оригинальные изображения из архива
tests/                    # поведенческие тесты и QML smoke test
docs/                     # исходная спецификация и integration contract
```

Данные входят в интерфейс через `BackendBridge`, а не через MediaPipe-вызовы
из QML. Поддержаны posture + confidence + timestamp, события коррекций,
состояние мониторинга, результат калибровки и `QImage`-кадры.
Сигналы переводят обновления с рабочего потока на GUI-поток.
См. [ML_INTEGRATION.md](docs/ML_INTEGRATION.md).

## Проверки

```bash
.venv/bin/python -m unittest discover -s tests -p 'test_*.py' -v
QT_QPA_PLATFORM=offscreen .venv/bin/python tests/smoke_ui.py
```

На Windows задайте `$env:QT_QPA_PLATFORM="offscreen"`, затем запустите
`.venv\Scripts\python.exe tests/smoke_ui.py`.

Smoke test рендерит **43 экрана/состояния** в **1440×900** и **1280×720**,
нажимает реальные QML-кнопки, переключает состояния и периоды, вводит текст,
проверяет настройки, калибровку и передачу кадра. Ошибки загрузки и QML warnings
считаются провалом. Для PNG передайте `--screenshots /существующая/директория`.

## Дизайн

Источник — [дизайн-спецификация](docs/posture_app_design_spec.md),
исходная QML-заготовка и приложенные изображения.
Отдельные полноэкранные mockup-файлы в исходных материалах отсутствовали.

Целевое окно — **1440×900**, минимальное — **1280×720**; длинные страницы прокручиваются.
Сохранены тёмный sidebar, cream canvas, rounded cards и постоянная цветовая семантика.
Шрифт: Manrope, если установлен; иначе Avenir Next / Segoe UI / DejaVu Sans / системный.
Дополнительные шрифты и сетевые ресурсы при запуске не загружаются.
