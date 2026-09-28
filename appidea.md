# Journiq

## Track Every Journey.

**Product Type:** Personal GPS Journey Tracking & Journey Mapping App
**Platform:** Android
**Framework:** Flutter / Dart
**Design Language:** Modern Material 3 + Futuristic Mobility UI
**Architecture:** Clean Architecture + Local First
**Primary Storage:** Local SQLite/Drift
**Backend:** None in V1
**Authentication:** None in V1

---

# 1. Product Vision

Journiq is a modern personal journey-tracking application designed to record, visualize, analyze, and preserve every journey a user makes.

The application is NOT limited to cycling.

A journey can be:

* Walking
* Bicycle
* Motorcycle
* Car
* Bus
* Train
* Other

The core idea is:

> **Start a journey → Journiq continuously understands the user's movement → visually tracks the route → records statistics → captures environmental information → saves the journey locally → builds a permanent personal journey history and cumulative map.**

Journiq should feel like a modern navigation/mobility application rather than a traditional CRUD application.

The application must have a polished, futuristic, responsive interface with smooth animations, modern cards, map-centric screens, floating controls, clear typography, and strong visual hierarchy.

---

# 2. Core Product Principles

## 2.1 Local First

Journiq V1 must work without a backend.

All important journey information must be stored locally.

The user must be able to:

* Start journeys
* Track journeys
* Pause/resume
* Stop/save journeys
* View history
* View journey details
* View statistics
* View cumulative map
* Delete journeys

without requiring an account or server.

Future backend synchronization may be introduced in V2, but V1 must not depend on it.

---

# 3. Important UX Requirement

Journiq must NOT behave like a basic map with a GPS dot.

The live tracking experience should feel similar to modern navigation applications.

The user's current position must be continuously represented on the map.

When tracking:

* Current location marker is visible
* Map camera follows the user
* Marker movement is smooth
* Route polyline grows continuously
* Camera automatically recenters
* User can manually pan the map
* After manual interaction, automatic following temporarily pauses
* A "recenter/follow me" button appears
* Pressing it returns the camera to the current position
* User can zoom in/out
* User can rotate the map if supported
* Heading/orientation may be represented when reliable
* GPS accuracy should be visually represented when appropriate

The experience should feel like:

> "Journiq is following me."

rather than:

> "There is a static marker somewhere on the map."

---

# 4. Application Navigation

The application should have a modern bottom navigation structure.

Recommended primary navigation:

1. Home
2. Journey
3. Map
4. Statistics
5. History

The exact navigation implementation may be adjusted if a better UX is found.

However, the application must always provide easy access to:

* Start Journey
* Current Journey
* Journey History
* Personal Map
* Statistics
* Settings

---

# 5. Home Screen

The Home screen should immediately communicate the user's journey activity.

## Header

Display:

* Journiq logo/name
* Short greeting or contextual text
* Current date
* Optional weather summary

Avoid excessive decorative elements.

---

## Primary Start Journey Card

A large visually prominent card:

**Start a Journey**

The card should communicate that tracking can begin immediately.

Example:

```
START JOURNEY

Choose your mode
and begin tracking your route.

[ Start Journey ]
```

The Start button should be highly visible.

---

# 6. Journey Mode Selection

Before starting a journey, user selects:

* Walking
* Bicycle
* Motorcycle
* Car
* Bus
* Train
* Other

Each mode should have:

* Appropriate icon
* Label
* Subtle animation/visual feedback
* Selected state

Example:

```
🚶 Walking
🚲 Bicycle
🏍 Motorcycle
🚗 Car
🚌 Bus
🚆 Train
••• Other
```

Use a polished grid/card layout.

Do NOT use old-fashioned plain dropdown UI.

---

# 7. Live Journey Screen

This is the most important screen in the application.

The map should occupy most of the screen.

The UI must be map-first.

Recommended structure:

```
┌───────────────────────────────┐
│  ← Walking       ● Tracking   │
│                               │
│                               │
│             MAP               │
│                               │
│        ● current location     │
│       ╱                        │
│      ╱ route                  │
│     ╱                         │
│                               │
│                        ◎      │
│                     Recenter  │
│                               │
├───────────────────────────────┤
│  2.84 km     18:42            │
│  9.1 km/h     Avg 8.7 km/h    │
├───────────────────────────────┤
│   Pause              Stop     │
└───────────────────────────────┘
```

---

# 8. Live Map Requirements

The map must:

* Show current user location
* Show route polyline
* Automatically follow user
* Update camera smoothly
* Support zoom
* Support pan
* Support recenter
* Show route progress
* Avoid unnecessary map redraws
* Handle GPS updates efficiently

The current position marker should be modern.

Prefer:

* Circular location indicator
* Accuracy ring
* Direction/heading indicator when available
* Smooth interpolation between GPS samples

Do not use a generic static pin unless necessary.

---

# 9. Google-Maps-Like Camera Following

Implement a dedicated map-following controller.

When tracking begins:

1. Obtain valid GPS position.
2. Move camera to current position.
3. Set an appropriate zoom level.
4. Start following the user.
5. Each valid GPS update moves the camera toward the new location.
6. Camera movement should be animated rather than abruptly jumping.

Example behavior:

```
GPS Update
     ↓
Validate location
     ↓
Calculate movement
     ↓
Update marker
     ↓
Update route
     ↓
Animate camera
     ↓
Maintain user visibility
```

The user's location should generally remain around the center/lower-center portion of the visible map while navigation is active.

---

# 10. Manual Map Interaction

The user must be able to interact with the map while a journey is running.

If the user:

* pans
* zooms
* rotates

then automatic camera following should temporarily stop.

A floating button should appear:

**◎ Follow Me**

When pressed:

* camera returns to current location
* appropriate zoom is restored
* follow mode becomes active again

This behavior is critical.

Do not constantly force the camera back to the user's position when the user intentionally explores the map.

---

# 11. Current Location Marker

The current position marker must update continuously.

The marker should include:

* Latitude/longitude internally
* GPS accuracy
* Current speed
* Optional heading
* Visual accuracy radius

Example:

```
       ↑ heading
      / \
     / ● \
       ○
  accuracy radius
```

The marker should animate between GPS samples if practical.

Do not visually teleport the marker every time a GPS update arrives.

---

# 12. GPS Tracking Engine

Create a dedicated tracking service.

Example abstraction:

```text
LocationService
TrackingService
JourneyTrackingController
```

Do not put GPS business logic directly inside widgets.

The GPS service should provide:

* latitude
* longitude
* timestamp
* speed
* accuracy
* heading when available

---

# 13. GPS Quality Filtering

GPS data must be filtered before being used.

Reject or ignore:

* Very poor accuracy
* Duplicate coordinates
* Impossible jumps
* Unrealistic speed spikes
* Invalid timestamps
* Stale location samples
* Clearly corrupted readings

Example:

```text
GPS sample
   ↓
Accuracy validation
   ↓
Timestamp validation
   ↓
Duplicate detection
   ↓
Distance validation
   ↓
Speed sanity check
   ↓
Accept / Reject
```

Filtering must prevent:

* 500 km/h walking speed
* random jumps across cities
* huge distance increases while stationary
* route zig-zag caused by GPS noise

---

# 14. Distance Calculation

Distance must be calculated from accepted GPS points.

Use geodesic/Haversine-style distance calculations.

Internal unit:

```text
meters
```

Display:

```text
km
```

Examples:

```text
850 m
2.84 km
12.45 km
```

Distance must NOT be calculated from raw unfiltered GPS samples.

---

# 15. Speed

Track:

* Current speed
* Average speed
* Maximum speed

Display km/h.

Current speed should preferably be derived from reliable GPS speed and/or distance/time between accepted samples.

Ignore unrealistic speed spikes.

Maximum speed must be based on validated samples.

---

# 16. Journey Duration

Track two concepts:

### Total elapsed time

From journey start to journey end.

### Active duration

Only time during which the journey was actively tracking.

Paused time must not contribute to active duration.

Example:

```
Started: 10:00
Paused: 10:20
Resumed: 10:30
Stopped: 11:00

Elapsed time = 60 min
Active time = 50 min
```

Average speed should use active duration.

---

# 17. Pause / Resume

When user presses:

**Pause**

the application must:

* Stop counting active duration
* Stop adding movement distance
* Stop adding journey points
* Keep journey state locally
* Keep enough information to resume safely
* Clearly show paused state

Example:

```
PAUSED

Journey tracking is temporarily paused.

[ Resume Journey ]
[ Stop Journey ]
```

When Resume is pressed:

* Continue tracking
* Continue active duration
* Continue route
* Do not create artificial route segments across the pause

---

# 18. Stop Journey

Pressing Stop should not immediately save.

Show confirmation:

```
End Journey?

Your journey will be saved locally.

Distance       5.82 km
Active time    42 min
Avg speed      8.3 km/h

[ Continue ]
[ End Journey ]
```

After confirmation:

1. Stop GPS tracking.
2. Capture final valid location.
3. Finalize statistics.
4. Fetch weather snapshot.
5. Determine covered areas.
6. Save journey.
7. Show journey summary.

---

# 19. Background / Minimized Tracking

This is a critical requirement.

The user must be able to minimize Journiq while a journey is running.

Example:

```
Start Journey
      ↓
Press Home
      ↓
Phone screen minimized
      ↓
Journiq continues tracking
      ↓
User travels
      ↓
Return to Journiq
      ↓
Current route is still available
```

Tracking must continue while the application is:

* Minimized
* In background
* Screen locked, where Android/device restrictions allow it

Use Android foreground-service-compatible location tracking.

The application should display a persistent notification while actively tracking.

Example:

```
Journiq
Journey in progress

Walking • 3.42 km
18 min active

[ Open ]
[ Pause ]
```

Do not silently lose tracking when the app is backgrounded.

---

# 20. Android Background Location

The implementation must properly handle Android location requirements.

Support:

* Runtime location permission
* Location service enabled/disabled
* Foreground location service
* Background operation
* Android lifecycle changes
* Activity recreation
* App resume
* Screen lock/unlock

Do not assume that foreground-only GPS behavior is sufficient.

---

# 21. Lifecycle Handling

The tracking engine must be independent of a particular screen widget lifecycle.

For example:

The user starts a journey.

Then:

```text
LiveScreen
   ↓
App minimized
   ↓
App background
   ↓
Screen locked
   ↓
App reopened
```

The journey must remain alive.

Do not tie the tracking subscription only to:

```text
Widget.dispose()
```

The tracking engine should be managed by an application-level service/controller.

---

# 22. Local Journey Persistence

Production journey data must use:

**SQLite + Drift**

Do not use SharedPreferences as the primary journey database.

SharedPreferences may only be used for small preferences such as:

* onboarding completion
* theme preference
* map settings
* selected units

---

# 23. Database Schema

## journeys

Fields:

```text
id
mode
startTime
endTime
activeDurationSeconds
distanceMeters
averageSpeedKmh
maxSpeedKmh

startLatitude
startLongitude
endLatitude
endLongitude

weatherTemperature
weatherCondition
weatherHumidity
weatherWindSpeed
weatherRainProbability
weatherObservedAt

areasCovered

createdAt
```

---

## journey_points

Fields:

```text
id
journeyId
latitude
longitude
timestamp
speedKmh
accuracyMeters
heading
```

Foreign key:

```text
journey_points.journeyId
        ↓
journeys.id
```

Deleting a journey must also delete its associated journey points.

---

# 24. Database Reliability

The application must handle:

* database initialization
* migrations
* schema upgrades
* corrupted/incomplete journey recovery where practical
* transactions
* atomic journey save
* atomic journey deletion

A journey must never appear in History without its required data.

---

# 25. Weather

Weather must never block GPS tracking.

Weather is supplementary.

The application should retrieve:

* temperature
* weather condition
* humidity
* wind
* precipitation/rain probability where available

Use a free/free-tier weather API.

Network failure must not prevent:

* tracking
* stopping
* saving
* history access

---

# 26. Rain Forecast Requirement

The live map should contain a compact weather intelligence card.

Example:

```
┌─────────────────────────────┐
│ 🌦 WEATHER                  │
│ 29°C • Partly Cloudy        │
│                             │
│ Rain outlook                │
│                             │
│ Next 2 hours                │
│ 15% → 20% → 35% → 45%       │
│                             │
│ Rain may be possible later  │
└─────────────────────────────┘
```

The application should communicate:

> Whether rain is likely within approximately the next 2 hours.

Do NOT claim certainty.

Use language such as:

* "Low chance of rain"
* "Rain may be possible"
* "Rain probability increasing"
* "High chance of rain"

The forecast should be based on the selected weather API's available hourly/short-term precipitation data.

If weather data is unavailable:

```text
Weather unavailable
Tracking is unaffected.
```

---

# 27. Weather Card Placement

The weather card should be visually integrated into the map.

It should NOT occupy excessive screen space.

Recommended:

* compact floating card
* semi-transparent/modern surface
* expandable details

Possible structure:

```text
🌧 32%
Rain possible within 2h
29°C
```

Tap:

```text
Weather Details
```

to show a more detailed forecast.

---

# 28. Areas Covered

Every completed journey should determine the geographical areas visited.

For example:

```text
Areas Covered

Dhaka
Mirpur
Agargaon
Mohammadpur
```

Implementation should use reverse geocoding.

Important:

Do NOT reverse-geocode every GPS point.

Instead:

1. Sample route points.
2. Detect meaningful movement.
3. Reverse-geocode selected points.
4. Cache results.
5. Deduplicate area names.
6. Store the final unique list.

This avoids excessive API calls.

If reverse geocoding fails:

```text
Areas unavailable
```

The journey must still save successfully.

---

# 29. Offline Map / District Map Pack

Journiq should support an offline-first map experience.

When appropriate map data is available, the application should allow the user to download an offline map pack for their current district.

Example:

```text
Offline Map

Current area:
Dhaka District

Map size:
~XXX MB

[ Download District Map ]
```

After download:

```text
✓ Dhaka District
Available Offline
```

The exact download size must be calculated from the selected tile/data strategy rather than hardcoded.

---

# 30. District Detection

The application may determine the user's current district through reverse geocoding/geographical metadata.

Example:

```text
Current District
Dhaka
```

The user should also be able to select another district manually.

---

# 31. Offline Map Architecture

Do not simply download unlimited OSM tiles blindly.

The implementation must consider:

* OpenStreetMap licensing
* tile provider terms
* attribution
* rate limits
* storage size
* zoom level
* cache management
* update strategy

Use a proper offline map provider/data package where appropriate.

The application must show required attribution.

Do not hardcode an inappropriate production tile endpoint merely to make offline download work.

---

# 32. Map Modes

Support:

### Online Mode

Map data loads from the configured online provider.

### Offline Mode

Downloaded local map data is used.

### Automatic Mode

Prefer online map when available and fall back to downloaded offline data.

The application should gracefully handle network loss.

---

# 33. Offline Map Download UX

The download screen should show:

```text
Dhaka District

Map Coverage
████████████░░░░ 78%

Downloaded: 248 MB
Estimated remaining: 71 MB

[ Pause ]
[ Cancel ]
```

After completion:

```text
✓ Offline map ready
```

Downloads should be resumable if practical.

---

# 34. My Journey Map

Journiq must maintain a cumulative personal map.

This is different from the live journey map.

The My Journey Map shows routes from completed journeys.

Example:

```text
MY JOURNEY MAP

Total routes: 27
Total distance: 384.7 km

        ───────
      ╱
 ────╯      ─────
          ╱
    ─────╯
```

Each completed journey contributes its route.

---

# 35. Cumulative Map Performance

Do NOT load every GPS point from every journey into the map simultaneously.

For large histories:

* simplify polylines
* downsample points
* load only visible journeys when possible
* use spatial filtering
* avoid unnecessary rebuilds
* cache simplified route geometry

The map must remain responsive with hundreds of journeys.

---

# 36. History

History must show completed journeys newest first.

Example:

```text
Today

🚶 Walking
5.82 km • 42 min
Avg 8.3 km/h

Dhaka → Mirpur
29°C • Partly Cloudy


Yesterday

🚗 Car
18.4 km • 36 min
```

Each item should show:

* Mode
* Date
* Distance
* Duration
* Average speed
* Optional start/end area
* Weather summary

---

# 37. Journey Details

Opening a journey should show:

```text
Walking

5.82 km
42 min active

Average Speed
8.3 km/h

Maximum Speed
12.7 km/h

Start
10:12 AM

End
10:54 AM

Weather
29°C
Partly Cloudy

Areas Covered
Mirpur
Agargaon
Dhaka

Route
[ MAP ]
```

The full route must be rendered.

---

# 38. Delete Journey

Delete must work.

Before deletion:

```text
Delete this journey?

This will permanently remove:
• Journey information
• Route points
• Weather snapshot
• Areas covered

[ Cancel ]
[ Delete ]
```

Deletion must remove both:

```text
journeys
journey_points
```

using the database relationship.

---

# 39. Statistics

Statistics should provide useful personal analytics.

Minimum:

* Total journeys
* Total distance
* Total active time
* Average journey distance
* Average speed
* Longest journey
* Maximum recorded speed
* Journeys this month
* Distance this month

---

# 40. Time Filtering

Monthly statistics must use:

```text
current year + current month
```

not merely the month number.

For example:

September 2026 must NOT include:

September 2025
September 2024

---

# 41. Mode Statistics

Show statistics by transport mode.

Example:

```text
Walking
Journeys: 18
Distance: 72.4 km

Car
Journeys: 9
Distance: 182.7 km

Bicycle
Journeys: 6
Distance: 129.6 km
```

Do not present fake data.

If no data exists:

```text
No journeys yet.
Start your first journey to see statistics.
```

---

# 42. Futuristic UI Direction

The visual design must be significantly more modern than a standard Flutter starter application.

Avoid:

* old-fashioned large plain cards
* excessive borders
* default Flutter-looking buttons
* unnecessary gradients everywhere
* excessive glassmorphism
* clutter
* huge text
* poor spacing
* inconsistent icons
* placeholder UI

Target aesthetic:

* modern
* premium
* clean
* futuristic
* mobility/navigation focused
* map-centric
* responsive
* information dense but readable

---

# 43. Glass / Surface Design

Use subtle glass/surface effects only where useful.

For example:

* floating map controls
* weather card
* live metric panel
* bottom control sheet

Avoid turning the entire application into transparent glass.

The map must remain visually dominant.

---

# 44. Color System

Create a consistent design system.

Example conceptual palette:

```text
Background
Surface
Surface Elevated
Primary
Secondary
Success
Warning
Danger
Text Primary
Text Secondary
```

The exact colors may be selected by the implementation agent, but they must form a coherent system.

Prefer strong contrast and accessibility.

---

# 45. Typography

Use a modern readable font hierarchy.

Examples:

```text
Large metric:
32–40 px

Screen title:
24–28 px

Section:
18–20 px

Body:
14–16 px

Supporting text:
12–14 px
```

Do not use oversized typography that consumes useful map space.

---

# 46. Animations

Use subtle, purposeful animations.

Examples:

* Start Journey transition
* Mode selection
* GPS marker movement
* Route drawing
* Pause/resume
* Bottom sheet transition
* Statistics chart entrance
* Weather updates
* Recenter animation

Avoid animations that reduce performance.

---

# 47. Performance

The app must remain responsive during GPS tracking.

Do not perform expensive work on the Flutter UI thread.

Avoid:

* rebuilding the entire screen for every GPS point
* repeatedly rebuilding large polylines unnecessarily
* reverse-geocoding every point
* database writes for every tiny UI update
* unnecessary map controller recreation

Separate:

```text
GPS ingestion
Statistics calculation
Persistence
Map rendering
UI state
```

appropriately.

---

# 48. GPS Persistence Strategy

During an active journey, accepted GPS points should be persisted periodically and/or transactionally enough to protect against app/process interruption.

Do not keep the entire journey only in RAM.

If the app crashes or Android kills the process, the implementation should minimize data loss.

A recoverable active journey state is preferred.

---

# 49. Active Journey Recovery

If the application starts and finds an unfinished journey:

```text
Journey in progress

A previous journey appears to be active.

[ Resume ]
[ End & Save ]
[ Discard ]
```

Never silently discard a user's active journey.

---

# 50. Error Handling

Errors must be user-friendly.

Do not expose raw exceptions such as:

```text
PlatformException(...)
```

Instead:

```text
Location unavailable

Please enable GPS and try again.
```

---

# 51. GPS Permission UX

If permission is denied:

```text
Location permission required

Journiq needs your location to track journeys.

[ Allow Location ]
```

If permanently denied:

```text
Location permission is blocked.

Please enable location permission from Android Settings.

[ Open Settings ]
```

If GPS/location service is disabled:

```text
Location services are disabled.

Please enable GPS to start tracking.

[ Enable Location ]
```

---

# 52. GPS Accuracy Indicator

During tracking, optionally show:

```text
GPS
±8 m
```

Possible states:

```text
Excellent
Good
Weak
Poor
```

Do not overwhelm the user with technical details.

---

# 53. Empty States

Every empty screen must have a meaningful state.

History:

```text
No journeys yet.

Your journeys will appear here after you
complete your first trip.

[ Start Journey ]
```

Statistics:

```text
No statistics yet.

Complete a journey to start building your
personal travel insights.
```

My Map:

```text
Your journey map is waiting.

Complete journeys to build your personal
map of places you've travelled.
```

---

# 54. Settings

Include:

* Map settings
* Distance unit
* Theme
* Offline maps
* Location settings
* Weather settings
* Data/storage information
* About Journiq

Avoid unnecessary backend/account settings in V1.

---

# 55. Data Management

Provide a way to understand local storage usage.

Example:

```text
Journiq Storage

Journeys: 42
GPS points: 184,392

Database: 18.4 MB
Offline maps: 612 MB
```

Optional:

```text
Clear map cache
```

Do NOT provide destructive actions without confirmation.

---

# 56. Architecture

Use Clean Architecture.

Suggested:

```text
lib/
├── core/
│   ├── constants/
│   ├── errors/
│   ├── extensions/
│   ├── utils/
│   ├── theme/
│   └── widgets/
│
├── database/
│   ├── app_database.dart
│   ├── tables/
│   ├── daos/
│   └── migrations/
│
├── features/
│   ├── home/
│   ├── journey/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── history/
│   ├── statistics/
│   ├── map/
│   ├── weather/
│   └── settings/
│
└── main.dart
```

Business logic must NOT live directly inside widgets.

---

# 57. Service Abstractions

Create clear abstractions.

Examples:

```dart
abstract class LocationService {}

abstract class WeatherService {}

abstract class GeocodingService {}

abstract class JourneyRepository {}

abstract class MapService {}
```

Implementation details should be replaceable.

This is important because Journiq may receive a backend in V2.

---

# 58. State Management

Use Riverpod.

Separate state for:

* current journey
* GPS state
* tracking state
* current location
* route
* metrics
* weather
* history
* statistics
* offline maps

Do not use excessive global mutable state.

---

# 59. Map Technology

Use `flutter_map` or another appropriate Flutter mapping library.

Use:

* OpenStreetMap-compatible data/provider
* `latlong2`
* appropriate tile provider
* proper attribution

Do not embed Google Maps unless explicitly required.

---

# 60. Dependencies

Use appropriate packages such as:

```text
flutter_riverpod
drift
drift_flutter
geolocator
permission_handler
flutter_map
latlong2
http
intl
shared_preferences
```

Additional packages may be introduced when technically justified.

Avoid unnecessary dependencies.

---

# 61. Security & Privacy

Journiq V1 is local-first.

Location history is sensitive user data.

Therefore:

* Do not upload location data
* Do not introduce analytics that secretly transmit journey coordinates
* Do not introduce authentication
* Do not introduce cloud synchronization
* Do not expose journey data externally

The user controls their local journey data.

---

# 62. Offline Behavior

Journiq should remain useful without internet.

Without internet:

Still available:

* GPS tracking
* distance
* speed
* duration
* route recording
* journey saving
* history
* statistics
* downloaded offline maps

May be unavailable:

* live weather
* reverse geocoding
* new map tiles
* district map download

These failures must not break journey tracking.

---

# 63. Network Failure

Weather failure:

```text
Weather unavailable
```

Map network failure:

```text
Offline map available
```

Geocoding failure:

```text
Area information unavailable
```

Never:

```text
Journey save failed because weather failed.
```

---

# 64. Map Location Selection

The user must also be able to manually set/explore a location on the map.

Outside active tracking:

* Search/select a location where technically feasible
* Tap the map to inspect a location
* Move the map
* Recenter to current location

During tracking:

* Current location remains available
* User can pan/explore
* Follow Me returns to current location

The implementation should keep this separate from changing the actual GPS tracking position.

A map selection must NOT fake or modify the device's real GPS location.

---

# 65. Journey Start Location

When starting:

1. Request/check permission.
2. Verify location services.
3. Wait for a sufficiently accurate initial location.
4. Display initial position.
5. Initialize route.
6. Start tracking.
7. Start active timer.
8. Begin persistence.

Do not start a journey with an obviously invalid first point.

---

# 66. Journey Summary

After saving:

```text
Journey Complete 🎉

Walking

5.82 km
42 min active

Average
8.3 km/h

Maximum
12.7 km/h

Weather
29°C • Partly Cloudy

Areas
Mirpur • Agargaon • Dhaka

[ View Journey ]
[ Done ]
```

The summary should feel rewarding but not childish.

---

# 67. Real-Time Metrics

During tracking show:

Primary:

```text
Distance
Active Time
Current Speed
```

Secondary:

```text
Average Speed
Max Speed
GPS Accuracy
```

Metrics must update even when GPS movement is temporarily low.

The timer must not depend solely on GPS updates.

---

# 68. Tracking State Model

Use explicit states.

Example:

```text
idle
starting
waitingForGps
tracking
paused
stopping
saving
completed
error
```

This avoids ambiguous UI behavior.

---

# 69. App Lifecycle State Model

Track independently:

```text
foreground
background
locked
resumed
```

The tracking engine should remain functional across lifecycle transitions.

---

# 70. Testing Requirements

Unit tests:

### Distance

Verify known coordinate distances.

### Speed

Verify:

* normal movement
* zero movement
* unrealistic speed
* invalid samples

### Duration

Verify:

* start
* pause
* resume
* stop
* multiple pauses

### GPS filtering

Verify:

* poor accuracy rejected
* duplicate rejected
* jump rejected
* impossible speed rejected

### Database

Verify:

* journey insert
* point insert
* journey retrieval
* point retrieval
* delete cascade
* migration

### Statistics

Verify:

* total distance
* average speed
* maximum speed
* monthly filtering
* current year/month filtering
* mode statistics

---

# 71. Widget Tests

Test:

* Home
* Mode selection
* Live journey
* Pause state
* Stop confirmation
* History
* Journey details
* Statistics
* Empty states
* Weather unavailable state

---

# 72. Integration / Device Testing

Must test on a real Android device.

Primary test device:

```text
Redmi K20 Pro
Android 11 / API 30
```

Test:

* permission flow
* GPS
* real movement
* background tracking
* screen lock
* minimize app
* resume app
* pause/resume
* stop/save
* history
* deletion
* statistics
* weather failure
* offline behavior

---

# 73. UI Runtime Safety

The application must have:

* no duplicate Hero tags
* no ParentDataWidget assertions
* no overflow errors
* no broken navigation
* no dead buttons
* no placeholder functionality presented as complete
* no infinite loading state
* no crashes during lifecycle changes

Every visible action must actually work.

---

# 74. Performance Testing

Check:

```text
flutter analyze
flutter test
flutter build appbundle --release
```

During device testing monitor:

* CPU
* RAM
* frame rendering
* GPS update frequency
* battery impact
* database growth

Avoid unnecessary rebuilds.

---

# 75. Release Build

Generate:

```text
AAB
```

using release configuration.

Verify:

* application name Journiq
* proper launcher icon
* Android permissions
* release build succeeds
* no debug-only behavior
* no development URLs
* no placeholder content

---

# 76. Branding

Application name:

**Journiq**

Tagline:

**Track Every Journey.**

Do not use:

```text
com.example.journiq
```

as the final production identity if a proper package/application ID can be selected.

Use an appropriate production package namespace.

---

# 77. Explicitly Excluded From V1

Do NOT implement:

* Spring Boot backend
* PostgreSQL backend
* Firebase backend
* Authentication
* User accounts
* WebSocket
* Cloud synchronization
* Live location sharing
* Friends
* Social feed
* Group journeys
* Kubernetes
* Admin panel
* Server-side analytics
* Chat
* Social profiles

V1 is strictly:

> Personal + Local + GPS + Map + Journey Analytics.

---

# 78. Future V2 Compatibility

Although V1 is local-first, architecture should make future backend integration possible.

Potential V2:

```text
Flutter App
     ↓
API
     ↓
Backend
     ↓
PostgreSQL
```

But V1 must NOT implement this.

Repositories and services should use abstractions so a remote implementation can be introduced later.

---

# 79. Critical Product Quality Requirement

The implementation agent must NOT assume that an existing feature is correct merely because code exists.

Before declaring the project complete:

1. Read this specification completely.
2. Audit the entire existing repository.
3. Identify incomplete or fake functionality.
4. Fix architectural problems.
5. Fix UI/UX problems.
6. Fix GPS problems.
7. Fix background tracking.
8. Fix database architecture.
9. Fix map following.
10. Implement offline map functionality properly.
11. Implement weather intelligence.
12. Implement areas covered.
13. Implement cumulative journey map.
14. Test the complete journey lifecycle.
15. Test on the real Redmi K20 Pro.
16. Run static analysis.
17. Run all tests.
18. Build release AAB.

Do not simply report that something is "implemented" because a class or widget exists.

Verify the actual behavior.

---

# 80. Definition of Done

Journiq V1 is considered complete only when this complete scenario works:

```text
Open Journiq
      ↓
Home screen
      ↓
Start Journey
      ↓
Select Walking
      ↓
Location permission
      ↓
GPS fix
      ↓
Live map opens
      ↓
Current location appears
      ↓
Camera follows user
      ↓
User moves
      ↓
Route grows
      ↓
Distance updates
      ↓
Current speed updates
      ↓
Average speed updates
      ↓
Weather card displays
      ↓
Rain outlook for next ~2 hours displays
      ↓
User pans map
      ↓
Follow mode pauses
      ↓
Follow Me button appears
      ↓
User taps Follow Me
      ↓
Camera follows again
      ↓
User minimizes app
      ↓
Tracking continues
      ↓
User locks screen
      ↓
Tracking continues where Android permits
      ↓
User opens app again
      ↓
Route and metrics are preserved
      ↓
User pauses
      ↓
Active duration stops
      ↓
User resumes
      ↓
Tracking continues
      ↓
User stops journey
      ↓
Confirmation
      ↓
Final GPS point
      ↓
Statistics calculated
      ↓
Weather snapshot
      ↓
Areas Covered
      ↓
SQLite/Drift transaction
      ↓
Journey saved
      ↓
Journey Summary
      ↓
History
      ↓
Journey Details
      ↓
Full route map
      ↓
Delete journey
      ↓
Database records removed
      ↓
Statistics updated
      ↓
My Journey Map updated
```

Every step must work.

---

# 81. Final Implementation Instruction For AI Agent

You are responsible for completing the Journiq application described in this document.

Do not create a superficial demo.

Do not replace real functionality with mock data.

Do not leave buttons that do nothing.

Do not silently omit difficult requirements.

If a requirement requires an architectural change, perform the architectural change.

If an existing implementation is wrong, replace it.

Prioritize correctness over preserving existing code.

Before changing anything:

```text
Read the complete specification.
Inspect the entire repository.
Understand the existing architecture.
```

Then implement systematically.

Use production-quality Flutter/Dart practices.

Keep business logic outside widgets.

Use Riverpod for state management.

Use Drift/SQLite for journey persistence.

Implement robust Android GPS/background tracking.

Implement Google-Maps-like camera following behavior.

Implement a proper current-location experience.

Implement offline map support with compliant map data/provider usage.

Implement weather and short-term rain outlook without making weather a dependency of tracking.

Implement Areas Covered.

Implement My Journey Map.

Make the UI futuristic, modern, responsive, and map-centric.

Do not overuse glassmorphism.

Do not modify this specification file unless explicitly instructed.

---

# 82. Required Final Verification Report

After implementation, report:

## Repository

* Files changed
* Architecture
* Major features

## GPS

* Permission handling
* Accuracy filtering
* Background tracking
* Lifecycle handling
* Camera following
* Current location behavior

## Database

* Drift schema
* Tables
* Relationships
* Migrations
* Delete behavior

## Maps

* Online map
* Offline map
* District download
* Current location
* Follow mode
* Route polyline
* My Journey Map

## Weather

* API/provider
* Current weather
* Next ~2 hour rain outlook
* Failure behavior

## Areas

* Reverse geocoding
* Sampling
* Deduplication
* Caching
* Failure behavior

## Testing

Report exact results of:

```bash
flutter pub get
flutter analyze
flutter test
flutter build appbundle --release
```

Also report real-device testing on:

```text
Redmi K20 Pro
Android 11 / API 30
```

Include any known limitations honestly.

Do not claim a feature is complete if it was not actually verified.
