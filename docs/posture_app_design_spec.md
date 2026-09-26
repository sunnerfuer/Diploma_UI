Да. Здесь уже можно перейти от «настроения интерфейса» к почти готовой **UI-спецификации**, по которой потом можно делать макет и только после этого — фронтенд.

Я бы сохранил рабочее название **PostureFlow** и зафиксировал направление так:

> **PostureFlow — desktop posture companion:** визуально спокойное SaaS-приложение для фонового контроля осанки. Главный объект интерфейса — не графики и не ML-метрики, а пользователь и текущая сессия мониторинга.

Главное правило всей системы: **Live Monitoring — функциональный и визуальный центр продукта. Dashboard лишь суммирует день, Statistics объясняет динамику, History хранит прошлое, Settings почти не отвлекает от основного сценария.**

---

# 1. Базовая структура desktop-приложения

Основной размер, под который я бы проектировал макеты:

**1440 × 900 px**

Минимальная комфортная ширина:

**1280 px**

Структура приложения:

```text id="hf2wv6"
┌───────────────┬──────────────────────────────────────────────────────────┐
│               │ Top header                                               │
│               ├──────────────────────────────────────────────────────────┤
│               │                                                          │
│   SIDEBAR     │                    PAGE CONTENT                          │
│    224 px     │                                                          │
│               │                                                          │
│               │                                                          │
└───────────────┴──────────────────────────────────────────────────────────┘
```

### Основные размеры

| Элемент | Размер |
|---|---:|
| Sidebar | 224 px |
| Header | 72 px |
| Content padding | 28–32 px |
| Grid | 12 колонок |
| Gap между колонками | 20 px |
| Gap между блоками | 20–24 px |
| Большие карточки radius | 24 px |
| Маленькие карточки radius | 18–20 px |
| Inputs / buttons radius | 12–14 px |

Интерфейс не должен быть полностью «воздушным». У референсов много пространства, но при этом блоки достаточно компактные. Именно это и дает ощущение дорогого SaaS, а не учебного макета.

---

# 2. Основная визуальная иерархия

На каждой странице должно быть максимум **три визуальных уровня**.

### Level 1 — Hero

Один главный объект экрана.

Например:

- Dashboard → **Today's posture score**
- Live → **Webcam**
- Statistics → **Posture quality trend**
- History → **Sessions**
- Settings → текущая группа настроек

### Level 2 — Supporting information

2–4 блока, которые объясняют hero.

Например:

- Good posture time
- Alerts
- Current session
- Posture distribution

### Level 3 — Details

Мелкие события, подписи, secondary controls.

Это избавит интерфейс от эффекта:

> «все карточки одинаково важные».

---

# 3. Sidebar

Я бы сделал sidebar постоянным на всех экранах.

```text id="1wcs7d"
┌──────────────────────┐
│  ◉ PostureFlow       │
│                      │
│  ▣  Dashboard        │
│  ◉  Live Monitoring  │
│  ◒  Statistics       │
│  ◷  History          │
│                      │
│                      │
│  ⚙  Settings         │
│                      │
│                      │
│ ┌──────────────────┐ │
│ │ ● Camera ready   │ │
│ │ Ready to monitor │ │
│ └──────────────────┘ │
│                      │
│   Maria        ···   │
└──────────────────────┘
```

### Active state

Не просто цвет иконки.

Активный пункт становится полноценным pill:

```text id="1uwxo5"
╭────────────────────╮
│ ◉  Live Monitoring│
╰────────────────────╯
```

Фон:

**lime `#D8F18B`**

Текст:

**dark `#1D1D25`**

Остальные пункты:

светло-серые/молочные.

---

# 4. Dashboard — окончательная структура

Dashboard должен за 3–5 секунд отвечать:

**Как я сидела сегодня?**

## Header

```text id="bc7q9m"
Good evening, Maria

Here’s your posture overview for today.                   Thu, Sep 10
```

Справа:

`bell` + avatar.

Я бы не добавлял поиск — в этом приложении он не нужен и будет выглядеть искусственно.

---

## Row 1 — основные показатели

### 1. Today's posture

Главная карточка.

**5 колонок**

Лиловый фон.

```text id="c4k99a"
TODAY'S POSTURE

84%

Good overall

↑ 6% from yesterday

You’re spending more time
in a neutral position.
```

Внизу маленькая декоративная mini-chart / sparkline.

---

### 2. Good posture

**3 колонки**

Лаймово-молочный фон.

```text id="vdbttv"
GOOD POSTURE

3h 42m

76% of monitored time
```

Дополнительный mini progress ring.

---

### 3. Corrections

**2 колонки**

Персиковый фон.

```text id="indb0l"
CORRECTIONS

11

4 fewer than yesterday
```

---

### 4. Current session

**2 колонки**

Темная карточка.

```text id="9htw41"
CURRENT SESSION

42 min

● Good posture

[ Open ]
```

Это будет маленький связующий элемент между Dashboard и Live Monitoring.

---

# 5. Dashboard — Row 2

## Posture trend

**8 колонок**

Белая карточка.

Title:

> **Posture trend**

Subtitle:

> Your posture quality during the last 7 days

Справа:

`[ Week ▾ ]`

График:

```text id="ocsv64"
100% ─────────────────────────────
 80%     ●────●       ●────●
 60%  ●        ●────●
 40%
      Mon Tue Wed Thu Fri Sat Sun
```

Сам график — без лишней сетки.

Оставить:

- X-axis;
- 50 / 75 / 100%;
- одну толстую плавную линию;
- точки только на hover либо на selected day.

---

## Today's focus

**4 колонки**

Я бы вместо очередной статистики сделал более «product-like» блок.

Title:

> **Today's focus**

```text id="57b0u2"
Your most common issue

Leaning forward

38 min total
↓ 12% compared with yesterday

[ View details ]
```

Фон: pale peach.

---

# 6. Dashboard — Row 3

## Today's posture distribution

**7 колонок**

```text id="j71izp"
Today's posture

Good posture          76%
████████████████

Leaning forward       17%
████

Leaning left           7%
██
```

Не donut.

Не pie chart.

Горизонтальные бары здесь будут выглядеть чище.

---

## Recent events

**5 колонок**

Title:

> **Recent posture events**

```text id="03r1n3"
15:42   Leaning forward
        Corrected after 18 sec

15:24   Leaning left
        Corrected after 9 sec

14:58   Session started
```

Внизу:

`View session history →`

События не должны выглядеть как тревожный журнал ошибок.

---

# 7. Live Monitoring — главный экран приложения

Этому экрану я бы отдал **самый сильный визуальный дизайн**.

Здесь должно быть значительно меньше карточек.

Основная сетка:

**8 колонок camera + 4 колонки status rail**

```text id="cec7rm"
┌───────────────────────────────────────────────┬─────────────────────────┐
│                                               │ Current posture         │
│                                               │                         │
│                                               │ GOOD POSTURE            │
│                                               │                         │
│                                               │ Detection stable   92%  │
│                                               ├─────────────────────────┤
│                 CAMERA                        │ Session                 │
│                                               │                         │
│                                               │ 00:42:16                │
│                                               ├─────────────────────────┤
│                                               │ Feedback                │
│                                               │                         │
│                                               │ You're sitting well.    │
│                                               │ Keep your shoulders     │
│                                               │ relaxed.                │
└───────────────────────────────────────────────┴─────────────────────────┘
```

---

# 8. Live Monitoring header

```text id="wt49gj"
Live Monitoring

Your posture is analyzed locally during the session.      ● Camera ready
```

Именно тут можно дать пользователю спокойное ощущение, что приложение работает.

Если локальная обработка в итоге действительно будет реализована, текст хорош. Если нет — заменим перед реализацией.

---

# 9. Webcam card

Размер — примерно:

**780–850 px × 480–520 px**

Это должен быть крупнейший объект всего приложения.

### Внутри webcam

В левом верхнем углу:

```text id="avv9hq"
● LIVE
```

В правом верхнем:

```text id="1myi7f"
Skeleton   [ON]
```

или иконка.

Снизу поверх камеры — очень тонкая полупрозрачная панель:

```text id="t6y54g"
Integrated Webcam                    30 FPS
```

FPS я бы показывал только если он реально понадобится для демонстрации диплома. Для обычного пользователя можно убрать.

---

# 10. Skeleton overlay

Очень аккуратный.

Не как MediaPipe debug output.

Я бы показывал:

- голову;
- плечи;
- локти;
- torso;
- точки ключевых landmarks;
- линию плеч.

Но никаких:

```text id="zrutn4"
x = 0.348
y = 0.675
landmark 12
angle = 42.1
```

Это всё должно оставаться техническим уровнем системы.

---

# 11. Current posture card

Это главный элемент правой панели.

### Neutral

```text id="pgzxad"
CURRENT POSTURE

● GOOD POSTURE

Your position looks balanced.

Detection confidence
92%
```

Фон:

pale lime.

---

### Leaning forward

```text id="8qpfwd"
CURRENT POSTURE

● LEANING FORWARD

Try moving your upper body
slightly back.

Detection confidence
89%
```

Фон:

pale peach.

---

### Leaning left

```text id="dm6s5a"
CURRENT POSTURE

● LEANING LEFT

Try bringing your shoulders
back toward the center.

Detection confidence
91%
```

Фон:

pale lilac.

---

# 12. Confidence

Я бы не делал слово `Confidence` слишком большим.

Вместо ML-интерфейса:

```text id="p500pb"
Detection confidence

██████████████── 92%
```

Или даже:

```text id="dpzrzl"
Detection stable              92%
```

На защите диплома процент останется видимым, но пользователь не воспринимает его как главную характеристику приложения.

---

# 13. Session card

Следующая карточка правой панели:

```text id="qxj7tj"
SESSION

00:42:16

Started at 19:48

Good posture     31 min
Corrections       6
```

Можно сделать темной.

Именно темные карточки хорошо будут связывать дизайн с четвертым референсом.

---

# 14. Feedback card

Третья карточка:

```text id="h7z8z4"
POSTURE TIP

You’re sitting well.

Keep your shoulders relaxed
and continue working normally.
```

или:

```text id="jq4f2f"
SMALL ADJUSTMENT

You’re leaning forward.

Move your upper body slightly
back and keep your neck relaxed.
```

Не нужно давать пользователю пять инструкций одновременно.

**Один detected state → одно короткое действие.**

---

# 15. Session controls

Под webcam, а не в sidebar.

Центрированная control bar:

```text id="la2j1o"
[ ❚❚ Pause ]                  [ ■ End session ]
```

При старте:

```text id="pp9yzi"
[ ● Start monitoring ]
```

Кнопка Start — самая заметная.

Высота примерно:

**48 px**

---

# 16. Live session timeline

Под основной областью можно сделать одну длинную тонкую карточку.

Title:

> **Session timeline**

```text id="uyg8oe"
19:48 ━━━━━━━●━━━━━━━━●━━━━━━●━━━━━━━━━━━━━━ 20:30
             ↑        ↑
           forward   left
```

И ниже несколько последних событий:

```text id="pq7ctb"
20:22   Leaning forward · 14 sec
20:08   Leaning left · 8 sec
19:55   Leaning forward · 21 sec
```

Это гораздо интереснее обычного списка логов и визуально хорошо демонстрирует работу модели.

---

# 17. Очень важный UX момент: предупреждения

Нельзя мигать интерфейсом каждый раз, когда модель на секунду изменила класс.

UI должен предполагать:

```text id="1m9ljr"
detected
↓
persists for X seconds
↓
gentle correction notification
```

Поэтому wording:

> Leaning forward detected

не нужно показывать пользователю как тревогу моментально.

Можно сначала изменить только статус.

А спустя, например, заданный интервал:

> A small adjustment may help.

Это потом хорошо ляжет и на программную логику проекта.

---

# 18. Statistics — структура

Главная идея:

**не сделать BI-dashboard.**

Header:

```text id="ybgejg"
Statistics

See how your posture changes over time.

[ Day ] [ Week ] [ Month ]                       Sep 7 — Sep 13
```

---

# 19. Statistics — KPI row

Три карточки.

### Posture quality

```text id="68f28o"
POSTURE QUALITY

82%

↑ 7% vs last week
```

Lilac.

### Neutral posture

```text id="ovf1y7"
GOOD POSTURE

6h 14m

76% of monitored time
```

Lime.

### Corrections

```text id="68sqra"
CORRECTIONS

24

↓ 12% vs last week
```

Peach.

---

# 20. Statistics — главный chart

Большая карточка, примерно **8 колонок**.

Title:

> **Posture quality over time**

Subtitle:

> Percentage of monitored time spent in a neutral posture

Большой line chart.

Это должен быть основной график всей аналитики.

---

# 21. Posture distribution

Справа, **4 колонки**.

Title:

> **Posture distribution**

```text id="xkbpoi"
Good posture       76%
████████████████

Leaning forward    17%
████

Leaning left        7%
██
```

Используем те же цвета, что и в Live.

Таким образом классы приобретают постоянную цветовую идентичность по всему приложению.

---

# 22. Secondary Statistics row

### Most common issue

```text id="tyesc9"
MOST COMMON ISSUE

Leaning forward

1h 24m this week

↓ 18% compared with last week
```

Peach card.

---

### Corrections by day

```text id="jsf4b8"
Corrections

24

    █
 █  █
 █  █ █
 █ █ █ █
 M T W T F S S
```

Простой bar chart.

---

### Consistency

Можно добавить полезный SaaS-like показатель:

```text id="xw6neg"
CONSISTENCY

5 / 7 days

You maintained 75%+ neutral
posture on five days this week.
```

Это визуально приятнее, чем еще один технический ML показатель.

---

# 23. History — не таблица, но и не giant cards

Лучший вариант здесь — **table/card hybrid**.

Header:

```text id="p54sp7"
History

Review your previous monitoring sessions.

[ Search sessions... ]         [ All sessions ▾ ]
```

---

# 24. Session list

Общий header:

```text id="bw0jsu"
DATE        DURATION       POSTURE QUALITY       MAIN ISSUE          STATUS
```

Но каждая строка имеет закругленный белый фон:

```text id="j8m9ph"
Sep 10      1h 45m              86%              Forward             View →
14:20
```

Следующая:

```text id="uo83yy"
Sep 9        52m                 78%              Left                View →
18:10
```

Это даст ощущение SaaS-продукта, но сохранит читаемость.

---

# 25. History session detail

При открытии сессии я бы не делал popup.

Лучше отдельное состояние страницы:

```text id="skcts7"
← Back to History

Sep 10 session
14:20 – 16:05

┌─────────────┐ ┌─────────────┐ ┌─────────────┐
│ Quality 86% │ │ 1h 45m      │ │ 8 alerts    │
└─────────────┘ └─────────────┘ └─────────────┘

┌──────────────────────────────────────────────┐
│ Session timeline                             │
└──────────────────────────────────────────────┘

┌──────────────────────────┐ ┌─────────────────┐
│ Posture distribution     │ │ Session summary │
│                          │ │                 │
│ Good       81%           │ │ Main issue:     │
│ Forward    14%           │ │ Forward         │
│ Left        5%           │ │                 │
└──────────────────────────┘ └─────────────────┘
```

---

# 26. Settings — структура

Settings лучше сделать спокойным.

Не 50 карточек.

Слева внутреннее меню:

```text id="fz57yo"
Camera
Notifications
Detection
Appearance
Profile
```

Справа один content panel.

---

# 27. Camera settings

Title:

> **Camera**

Description:

> Choose the camera used for posture monitoring.

Blocks:

```text id="5kmoq1"
Camera device
[ Integrated Webcam                 ▾ ]

Camera preview
┌───────────────────────────────────┐
│                                   │
│             PREVIEW               │
│                                   │
└───────────────────────────────────┘

Mirror camera                       [ ON ]

Show posture skeleton               [ ON ]
```

---

# 28. Notifications

```text id="pmv236"
Posture reminders                   [ ON ]

Notify me when poor posture
persists for

[ 10 seconds ▾ ]

Notification sound                  [ ON ]

Desktop notifications               [ ON ]
```

Можно добавить:

```text id="wb4rsy"
Reminder tone

○ Gentle
○ Standard
○ Minimal
```

Но не обязательно для первой версии.

---

# 29. Detection settings

Здесь уже начинается связь с ML.

```text id="kg5nbo"
Detection

Posture detection sensitivity

Low  ───────────●────────── High

Stable detection
Ignore very short posture changes   [ ON ]

Minimum detection duration
[ 3 seconds ▾ ]
```

И отдельный collapsed section:

```text id="bgt7ky"
Advanced settings          >
```

В нем позже могут быть:

- model version;
- confidence threshold;
- smoothing;
- debug overlay.

Это позволит сохранить профессиональный UI для обычного пользователя и одновременно иметь технические параметры для диплома.

---

# 30. Appearance

```text id="ou5spm"
Appearance

Theme

● Light
○ Dark
○ System

Accent style

● Soft lilac
○ Lime
○ Peach

Interface density

● Comfortable
○ Compact
```

Для диплома можно даже не реализовывать все варианты — но структура будет выглядеть полноценной.

---

# 31. Profile

Совсем простой блок.

```text id="j1c5ag"
Profile

Name
[ Maria ]

Default monitoring goal
[ 2 hours per day ▾ ]

Start week on
[ Monday ▾ ]
```

Не нужно превращать posture app в account-management platform.

---

# 32. Финальная pastel-система

Я бы зафиксировал палитру вот так.

### Foundations

| Token | HEX |
|---|---|
| Canvas | `#F7F5F0` |
| Surface | `#FFFFFF` |
| Surface subtle | `#F0EEE9` |
| Sidebar | `#1B1B24` |
| Primary text | `#202027` |
| Secondary text | `#777681` |
| Muted text | `#A09EA7` |
| Border | `#E8E5DE` |

### Accent family

| Accent | Main | Soft |
|---|---|---|
| Lilac | `#C9B6F4` | `#EEE8FC` |
| Lime | `#D6EF83` | `#EFF7D7` |
| Peach | `#F3B59C` | `#FBE7DD` |
| Pink | `#EFB6CF` | `#FAE7EF` |

---

# 33. Семантические цвета классов

Их очень важно не менять между страницами.

### Good posture

```text id="1tx75o"
Main: #CFEA7A
Soft: #EFF7D7
```

### Leaning forward

```text id="8nfjlz"
Main: #F1AE91
Soft: #FBE6DC
```

### Leaning left

```text id="xc5buq"
Main: #C9B6F4
Soft: #EEE8FC
```

### Pink

Не привязывать к классу.

Использовать для:

- decorative cards;
- secondary highlights;
- achievement/progress information.

Так система останется понятной при добавлении новых posture classes.

---

# 34. Как добавлять новые классы позже

Не создавать новую структуру UI.

Компонент:

```text id="fksdxg"
PostureStatus
```

получает:

```text id="zlwl64"
icon
label
description
semantic color
recommendation
```

Например позднее:

```text id="x2becw"
Cross-legged
```

или:

```text id="ketquf"
Leg asymmetry
```

просто станут новыми semantic variants.

Архитектуру экранов менять не придется.

---

# 35. Типографика

Я бы окончательно взял **Manrope**.

### Desktop type scale

| Использование | Размер |
|---|---:|
| Page title | 30 px / 700 |
| Hero number | 40 px / 700 |
| Posture state | 26–28 px / 700 |
| Section heading | 18 px / 650 |
| Card heading | 14 px / 650 |
| Body | 14 px / 450 |
| Secondary | 13 px / 450 |
| Micro / labels | 11–12 px / 600 |

Labels вроде:

`TODAY'S POSTURE`

можно писать uppercase и с небольшим letter-spacing.

---

# 36. Карточки

Не все карточки должны быть одинаковыми.

Я бы закрепил четыре вида.

### `SurfaceCard`

Белая.

Для:

- charts;
- history;
- settings;
- lists.

### `PastelMetricCard`

Цветная.

Для:

- today's score;
- good posture;
- corrections.

### `DarkCard`

Темная.

Для:

- current session;
- important CTA;
- selected summary.

### `StatusCard`

Меняет semantic цвет в зависимости от posture class.

Для Live Monitoring.

---

# 37. Shadows

Тут легко испортить весь стиль.

Я бы вообще не использовал заметные темные тени.

Пример ощущения:

```text id="qga8l2"
0 8px 30px rgba(30, 28, 35, 0.06)
```

и очень тонкая граница.

Большая часть разделения должна идти через:

- background;
- spacing;
- radius;
- subtle border.

---

# 38. Buttons

### Primary

```text id="hgeb7h"
Start monitoring →
```

Темный фон.

Белый текст.

На Live Screen можно использовать lime CTA перед стартом.

---

### Secondary

```text id="fjmvzu"
Pause
```

Белый фон + border.

---

### Tertiary

```text id="lkg6wg"
View details →
```

Без отдельного контейнера либо очень мягкий ghost.

---

### Destructive

```text id="hwjof9"
End session
```

Не ярко-красный.

Мягкий peach/red.

---

# 39. Chart styling

Чтобы все графики выглядели как одна система:

- линии 2–2.5 px;
- крупные радиусы;
- grid lines `#ECEAE5`;
- axis text muted grey;
- tooltip всегда белая маленькая rounded card;
- никакой легенды, если можно подписать данные непосредственно;
- максимум 3 semantic цвета одновременно.

Например tooltip:

```text id="a2rinb"
Wednesday, Sep 9

Posture quality
82%

Good posture
3h 18m
```

---

# 40. Что показывать пользователю, а что оставить ML-системе

### Пользователь видит

```text id="2m6unv"
Good posture
Leaning forward
Leaning left

92%
Stable detection

3h 42m good posture
11 corrections
84% posture quality
```

### Пользователь не видит постоянно

```text id="84l49h"
landmark coordinates
raw probabilities
feature vectors
pose angles
model input tensors
inference output
frame IDs
```

Но часть этого позже может существовать в:

> Settings → Detection → Advanced

или debug mode для защиты.

---

# 41. Компонентная структура всего приложения

В итоге дизайн можно собрать примерно из таких компонентов:

```text id="7vy6ka"
AppShell
├── Sidebar
│   ├── Logo
│   ├── NavigationItem
│   ├── CameraStatus
│   └── UserProfile
│
├── PageHeader
│
├── Cards
│   ├── SurfaceCard
│   ├── PastelMetricCard
│   ├── DarkCard
│   └── StatusCard
│
├── Monitoring
│   ├── WebcamPreview
│   ├── SkeletonOverlay
│   ├── PostureStatus
│   ├── DetectionConfidence
│   ├── SessionTimer
│   ├── FeedbackPanel
│   ├── MonitoringControls
│   └── SessionTimeline
│
├── Analytics
│   ├── MetricBlock
│   ├── LineChart
│   ├── BarChart
│   ├── DistributionBar
│   └── PeriodSelector
│
├── History
│   ├── SessionRow
│   ├── SessionSummary
│   └── SessionTimeline
│
└── Forms
    ├── Select
    ├── Toggle
    ├── Slider
    ├── SegmentedControl
    └── Input
```

Это уже достаточно конкретная система, чтобы интерфейс не приходилось придумывать заново во время реализации.

---

# 42. Визуальная роль каждой страницы

Я бы зафиксировал это как дизайнерское правило проекта:

| Screen | Что визуально главное |
|---|---|
| Dashboard | 84% Today's posture |
| Live | Webcam + Current posture |
| Statistics | Posture quality chart |
| History | Session chronology |
| Settings | Clean configuration panel |

Если на каком-то экране другой элемент начинает визуально доминировать, значит иерархия нарушена.

---

# 43. Как должен выглядеть продукт в целом

В готовом виде я вижу его так:

**Sidebar** — почти черный, компактный.  
**Background** — теплый cream.  
**Карточки** — mostly white.  
**Лиловый** — брендовый цвет.  
**Lime** — positive/action color.  
**Peach** — correction state.  
**Pink** — декоративный secondary accent.

Dashboard выглядит чуть более насыщенно и журнально.

Statistics — спокойнее и аналитичнее.

History — почти нейтральный.

Settings — максимально чистый.

А **Live Monitoring — самый визуально просторный экран**, где большая камера занимает большую часть рабочей зоны и всё остальное подчинено ей.

Именно это я бы теперь считал **утверждаемой UI-концепцией v1**. Следующим этапом логично уже не обсуждать абстрактный стиль, а сделать **детальный визуальный макет Live Monitoring со всеми конкретными блоками, размерами и расположением**, а затем на его основе Dashboard.