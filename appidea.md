# Journiq — Complete V1 Mobile App Development Prompt

## 1. Project Overview

Build a production-quality Flutter Android mobile application named **Journiq**.

### App Name

**Journiq**

### Tagline

**Track Every Journey.**

### Core Concept

Journiq is a modern journey-tracking application that allows users to record and review their journeys using GPS.

The app should not be limited to cycling. Users should be able to track different types of journeys such as:

* Walking
* Bicycle
* Motorcycle
* Car
* Bus
* Train
* Other

A user should be able to:

1. Select a journey mode.
2. Start a journey.
3. Track their GPS location.
4. See their live position on a map.
5. Draw the traveled route on the map.
6. Calculate distance, duration, and speed.
7. Pause and resume the journey.
8. Stop and save the journey.
9. View weather information.
10. See areas/locations covered during the journey.
11. Review previous journeys.
12. View statistics.
13. View all completed routes on a cumulative map.

The application should feel like a real-world polished product, not a demo application.

---

# 2. V1 Scope

Journiq V1 must be **local-first**.

There should be **NO backend/server dependency** in V1.

Do NOT implement:

* Spring Boot
* PostgreSQL server
* Firebase backend
* User authentication
* WebSocket
* Cloud synchronization
* Live location sharing
* Group journeys
* Friends
* Social features
* Kubernetes
* CI/CD
* Admin panel

Journey data should be stored locally on the Android device.

The architecture should nevertheless make it possible to introduce a backend in V2 without rewriting the entire application.

---

# 3. Recommended Technology Stack

Use:

* Flutter
* Dart
* Android
* Material 3
* Riverpod for state management
* Drift for SQLite database
* `drift_flutter`
* `flutter_map`
* `latlong2`
* `geolocator`
* `permission_handler`
* `http`
* `intl`
* `shared_preferences`

### Map

Use an OpenStreetMap-based map through `flutter_map`.

The implementation must respect the selected tile provider's:

* Attribution requirements
* Rate limits
* Usage policies
* Terms of service

Do not hardcode an inappropriate production tile endpoint without considering its usage policy.

### Weather

Use a free or free-tier weather API.

Weather failure must never prevent the user from recording or saving a journey.

---

# 4. Application Architecture

Use a clean, maintainable architecture.

Recommended structure:

```text
lib/
├── core/
│   ├── constants/
│   ├── theme/
│   ├── errors/
│   ├── utils/
│   └── services/
│
├── features/
│   ├── home/
│   ├── journey/
│   ├── journeys/
│   ├── statistics/
│   ├── weather/
│   └── settings/
│
├── database/
│   ├── app_database.dart
│   ├── tables/
│   └── daos/
│
└── main.dart
```

Follow:

```text
Presentation
      ↓
Domain
      ↓
Data
```

Business logic should not be placed directly inside UI widgets.

---

# 5. State Management

Use Riverpod or an equivalent lightweight state-management architecture.

Separate:

* UI state
* GPS state
* Journey state
* Database state
* Weather state
* Statistics state

Avoid creating one giant provider/controller containing the entire application.

---

# 6. Service Abstractions

Create clear service/repository abstractions.

At minimum:

```text
LocationService
WeatherService
GeocodingService
JourneyRepository
```

Optionally:

```text
MapService
```

The V1 repository will use SQLite locally.

Future V2 could implement:

```text
LocalJourneyRepository
RemoteJourneyRepository
```

without changing the presentation layer significantly.

---

# 7. Main Navigation

The application should have four main sections:

```text
Home
Journeys
Statistics
Settings
```

Use a polished Material 3 navigation experience.

---

# 8. Home Screen

The Home screen should feel like the main dashboard.

Show:

### Header

```text
Journiq
Track Every Journey.
```

### Current Weather

Display:

* Temperature
* Weather condition
* Weather icon
* Feels-like temperature
* Humidity
* Wind speed
* Rain probability when available

Weather should use the user's current location when appropriate.

If weather cannot be retrieved:

* Do not crash.
* Show a graceful fallback.
* Journey tracking must continue normally.

### Monthly Statistics

Show locally calculated statistics such as:

```text
Total Distance
Total Journeys
Active Time
Average Speed
```

### Primary CTA

A prominent:

```text
Start Journey
```

button.

The CTA should take the user to journey-mode selection.

---

# 9. Journey Mode Selection

Before starting a journey, allow the user to select:

```text
🚶 Walking
🚲 Bicycle
🏍️ Motorcycle
🚗 Car
🚌 Bus
🚆 Train
🧭 Other
```

Use attractive cards/icons.

The selected mode should be stored with the journey.

---

# 10. Start Journey Flow

When the user presses Start Journey:

### Step 1

Check whether location services are enabled.

### Step 2

Check location permissions.

Handle:

* Permission granted
* Permission denied
* Permission denied permanently
* GPS disabled

Provide clear user-friendly instructions.

### Step 3

Obtain the initial GPS position.

### Step 4

Create a new journey session.

### Step 5

Start GPS tracking.

### Step 6

Navigate to:

```text
Live Journey
```

---

# 11. Live Journey Screen

This is one of the most important screens.

The map should occupy most of the screen.

Display:

* Current position
* Start marker
* Current location marker
* Route polyline
* Map controls
* Current GPS information where useful

The route should visually show exactly where the user has traveled.

### Statistics Overlay

Display:

```text
Distance
00.00 km

Duration
00:00:00

Average Speed
00.0 km/h

Current Speed
00.0 km/h

Max Speed
00.0 km/h
```

The UI should update during tracking.

### Controls

Provide:

```text
Pause
Resume
Stop
```

Use large, accessible controls.

The user should not accidentally stop a journey.

Stopping should require confirmation.

---

# 12. GPS Tracking

Use `geolocator`.

Store GPS points containing:

```text
latitude
longitude
timestamp
speed
accuracy
```

GPS tracking must be battery-conscious.

Do not blindly save every GPS update.

Use sensible:

* Accuracy filtering
* Distance filtering
* Time filtering

Reject invalid GPS data such as:

* Extremely poor accuracy
* Impossible jumps
* Unrealistic speeds
* Duplicate points
* Clearly invalid coordinates

GPS signal loss should not crash the journey.

---

# 13. Distance Calculation

Calculate journey distance using geographic coordinates.

Distance should be stored internally in meters.

Display distance in kilometers.

Example:

```text
12450 meters
→
12.45 km
```

Do not count invalid GPS jumps toward distance.

---

# 14. Duration

Journey duration should represent **active journey time**.

If the journey is paused:

```text
Active duration stops.
```

When resumed:

```text
Active duration continues.
```

Paused time must not be included in active duration.

---

# 15. Speed Calculation

Calculate:

### Current Speed

Based on recent valid GPS information.

### Average Speed

```text
distance / active duration
```

### Maximum Speed

Maximum valid speed observed during the journey.

Filter unrealistic GPS spikes.

Do not allow one incorrect GPS reading to create an absurd maximum speed.

---

# 16. Pause / Resume

When paused:

* Stop active-duration accumulation.
* Stop distance accumulation.
* Stop speed/statistics updates.
* Keep the journey session alive.
* Clearly show paused state.

When resumed:

* Continue GPS tracking.
* Continue active duration.
* Continue distance calculation.
* Continue statistics.

---

# 17. Stop Journey

When the user presses Stop:

Show confirmation.

After confirmation:

1. Stop GPS tracking.
2. Save the final valid point if appropriate.
3. Calculate final statistics.
4. Capture current weather if available.
5. Determine areas covered if possible.
6. Save the journey locally.
7. Open Journey Summary.

---

# 18. Journey Summary Screen

After completing a journey, display:

```text
Journey Complete
```

Show:

* Journey mode
* Date
* Start time
* End time
* Distance
* Active duration
* Average speed
* Maximum speed
* Weather
* Areas covered
* Full route map

The map should display the complete route.

The user should be able to visually understand the exact path they traveled.

---

# 19. Areas Covered

Journiq should attempt to determine meaningful areas/locations covered during a journey.

Use reverse geocoding where practical.

Do NOT reverse-geocode every GPS point.

Instead:

* Sample meaningful points.
* Avoid duplicate locations.
* Cache results when practical.
* Handle API limits.
* Do not block journey saving if geocoding fails.

Example:

```text
Dhaka
Mirpur
Agargaon
Farmgate
Tejgaon
```

The exact output depends on the reverse-geocoding service.

If reverse geocoding is unavailable:

```text
Areas unavailable
```

should be acceptable.

The journey must still be saved.

---

# 20. Weather

Journiq should provide weather information for journeys.

### Current Weather

Show:

* Temperature
* Condition
* Weather icon
* Feels-like
* Humidity
* Wind
* Rain probability when available

### Journey Weather Snapshot

When a journey ends, attempt to save a weather snapshot associated with the journey.

Weather should be treated as an enhancement.

If the API fails:

```text
Weather unavailable
```

Do not fail the journey.

Do not make excessive API requests while tracking.

---

# 21. Offline-First Behavior

Core tracking must work without internet.

Without internet, the user should still be able to:

* Start journey
* Track GPS
* Calculate distance
* Calculate duration
* Calculate speed
* Pause
* Resume
* Stop
* Save journey
* View previous journeys
* View statistics

Internet-dependent functionality may fail gracefully:

* Map tiles
* Weather
* Reverse geocoding

Do not make the entire app dependent on network connectivity.

---

# 22. Database

Use SQLite through Drift.

## journeys

Suggested fields:

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
weatherFeelsLike
weatherHumidity
weatherWindSpeed
weatherRainProbability

createdAt
```

## journey_points

Suggested fields:

```text
id
journeyId

latitude
longitude
timestamp

speedKmh
accuracyMeters
```

Create a foreign-key relationship:

```text
journeys.id
      ↓
journey_points.journeyId
```

Deleting a journey should also delete its associated GPS points.

---

# 23. Journey History

The Journeys screen should show completed journeys.

Newest journeys first.

Each item can display:

```text
Walking
12.42 km
01:24:32
8.8 km/h
Weather
Date
```

Use appropriate icons and visual hierarchy.

The list should remain performant even with many journeys.

---

# 24. Journey Details

Selecting a journey should open a detailed screen.

Show:

* Date
* Start time
* End time
* Mode
* Duration
* Distance
* Average speed
* Maximum speed
* Weather
* Areas covered
* Complete route map

The route must be reconstructed from stored GPS points.

---

# 25. Delete Journey

Allow the user to delete a saved journey.

Show confirmation before deletion.

Deleting a journey must remove:

* Journey record
* Associated GPS points

Do not leave orphaned GPS records.

---

# 26. Statistics

Create a Statistics screen.

Display:

```text
Total Journeys
Total Distance
Total Active Time
Average Journey Distance
Average Speed
Longest Journey
Maximum Speed
```

Also provide:

### Monthly Statistics

For example:

```text
September

Distance
245.8 km

Journeys
18

Active Time
31h 42m
```

### Mode Statistics

Show statistics grouped by:

* Walking
* Bicycle
* Motorcycle
* Car
* Bus
* Train
* Other

Do not require a backend.

All statistics should be generated from the local database.

---

# 27. My Journey Map

Create a map view showing accumulated routes from completed journeys.

Example:

```text
My Journey Map
```

It should display route polylines from previous journeys.

Requirements:

* Efficient rendering
* Avoid loading unnecessary GPS points
* Allow zooming/panning
* Different journeys should remain distinguishable where practical
* Work from locally stored journey data

---

# 28. Settings

Settings can initially contain:

* Distance unit
* Speed unit
* Theme
* Map preferences
* Weather preferences
* About Journiq
* Privacy information

Keep V1 settings simple.

---

# 29. Permissions

Request only permissions that are actually needed.

Location permission must be handled properly.

Handle:

```text
Permission granted
Permission denied
Permission permanently denied
Location service disabled
```

Explain why location is required.

Do not request unnecessary permissions.

If background location is required, first verify the current Android requirements and only implement it if genuinely necessary for the V1 tracking design.

---

# 30. Android Lifecycle

Handle:

* App minimized
* Screen locked
* App resumed
* Temporary GPS loss
* Activity recreation
* Permission changes
* Journey in progress

Do not assume the app always remains in the foreground.

The implementation must prevent accidental loss of journey state.

---

# 31. Battery Optimization

GPS tracking can consume significant battery.

Use:

* Reasonable location accuracy
* Distance filters
* Appropriate update frequency
* Controlled database writes
* No unnecessary network calls
* No repeated reverse geocoding
* Stop GPS tracking after journey completion
* Stop unnecessary processing while paused

The goal is reliable tracking without unnecessarily draining the battery.

---

# 32. Error Handling

Gracefully handle:

### GPS

* GPS unavailable
* GPS signal lost
* Poor accuracy
* Invalid coordinates
* GPS jumps

### Permissions

* Permission denied
* Permanent denial
* GPS disabled

### Network

* No internet
* API timeout
* API error
* Rate limiting

### Weather

* API unavailable
* Invalid response

### Geocoding

* API unavailable
* Rate limit
* No result

### Database

* Insert failure
* Read failure
* Migration failure

### Journey

* Very short journey
* No valid GPS points
* Invalid journey state

The app should never crash because weather, maps, or geocoding are unavailable.

---

# 33. UI / UX Design

Journiq should look like a modern premium mobile application.

Use:

* Material 3
* Clean typography
* Rounded cards
* Consistent spacing
* Clear hierarchy
* Smooth transitions
* Appropriate icons
* Accessible touch targets
* Light and dark theme support

Avoid:

* Cluttered screens
* Excessive animations
* Tiny buttons
* Excessive colors
* Placeholder-looking UI
* Fake statistics
* Static demo data

The application should feel like something that could realistically be published to Google Play.

---

# 34. Privacy

Location data is sensitive.

V1 should be local-first.

Do not upload GPS data to any backend.

Do not implement public sharing.

Do not create public user profiles.

Clearly explain that journey data is stored locally in V1.

---

# 35. Security

Never:

* Hardcode private API secrets
* Commit secrets to Git
* Log sensitive GPS data unnecessarily
* Include debug logs containing private location data in release builds

For mobile APIs where a client-side API key is inherently exposed, design the integration appropriately and do not treat the key as a server-side secret.

---

# 36. Testing

Create meaningful tests for:

### Distance

Verify geographic distance calculation.

### Speed

Verify:

* Current speed
* Average speed
* Maximum speed
* Invalid speed filtering

### Duration

Verify:

* Start
* Pause
* Resume
* Stop

Paused time must not count toward active duration.

### GPS Filtering

Test:

* Poor accuracy
* Duplicate points
* GPS jumps
* Impossible speeds

### Database

Test:

* Insert journey
* Insert points
* Read journey
* Read points
* Update where required
* Delete journey
* Cascade/delete associated points

### Statistics

Verify monthly and mode-based calculations.

---

# 37. Performance

The application should remain responsive with a large number of stored journeys and GPS points.

Avoid:

* Loading all GPS points unnecessarily
* Excessive widget rebuilds
* Excessive database writes
* Excessive API calls
* Reverse geocoding every coordinate

Use pagination or efficient queries for history where appropriate.

---

# 38. No Fake Data

Do not use fake journey data in the final application.

During development, mock data may be used only for testing UI if necessary.

The production application must use:

```text
Real GPS
Real database
Real calculations
Real weather
Real route data
```

---

# 39. Release Quality

Before release:

* Remove debug UI.
* Remove fake data.
* Remove unnecessary logging.
* Verify Android permissions.
* Test on a real Android device.
* Test GPS tracking outdoors.
* Test poor GPS conditions.
* Test pause/resume.
* Test long journeys.
* Test app lifecycle.
* Test offline mode.
* Test weather failure.
* Test database persistence.
* Verify release build.
* Generate signed AAB.

The application should be ready for Google Play Store submission after proper testing.

---

# 40. Future V2 Architecture

Do not implement these in V1, but keep the architecture extensible for:

```text
User Authentication
        ↓
Spring Boot Backend
        ↓
PostgreSQL
        ↓
REST API
        ↓
WebSocket
        ↓
Live Journey Sharing
```

Potential V2 features:

* User accounts
* Cloud synchronization
* Multiple devices
* Journey sharing
* Live location
* Group journeys
* Friends
* Journey invitation
* Journey codes
* Shared maps
* Cloud backup
* Online analytics

The V1 local repository abstraction should make this migration easier.

---

# 41. Development Sequence

Implement the project incrementally.

## Step 1 — Environment Check

First inspect:

```text
Flutter version
Dart version
Android SDK
Java/JDK
Android Studio if installed
VS Code
Connected Android devices
```

Do not assume anything is installed.

---

## Step 2 — Project Foundation

Create:

```text
trailora
```

but use the application/product name:

```text
Journiq
```

Set up:

* Flutter project
* Material 3
* Theme
* App colors
* Typography
* Navigation
* App shell
* Home
* Journeys
* Statistics
* Settings

Do not implement GPS yet.

---

## Step 3 — Journey Mode

Implement journey-mode selection.

---

## Step 4 — GPS

Implement:

* Permission handling
* Location service
* GPS stream
* Accuracy filtering
* Point validation

---

## Step 5 — Calculations

Implement:

* Distance
* Duration
* Pause/resume
* Current speed
* Average speed
* Maximum speed

---

## Step 6 — Map

Implement:

* OpenStreetMap-based map
* Current location
* Start marker
* Current marker
* Route polyline
* Zoom
* Pan
* Fit route

---

## Step 7 — Database

Implement Drift database:

```text
journeys
journey_points
```

---

## Step 8 — Live Journey

Combine:

```text
GPS
+
Map
+
Statistics
+
Pause/Resume
+
Stop
```

---

## Step 9 — Journey Summary

Implement completed journey summary.

---

## Step 10 — History

Implement:

* Journey list
* Journey details
* Delete journey

---

## Step 11 — Weather

Implement:

* Current weather
* Weather snapshot
* Error handling

---

## Step 12 — Areas Covered

Implement reverse geocoding and meaningful area extraction.

---

## Step 13 — Statistics

Implement:

* Overall statistics
* Monthly statistics
* Mode statistics
* My Journey Map

---

## Step 14 — UI Polish

Improve:

* Typography
* Spacing
* Icons
* Animations
* Dark mode
* Empty states
* Error states
* Loading states

---

## Step 15 — Real Device Testing

Test on a physical Android device.

Test actual journeys.

---

## Step 16 — Release

Generate:

```text
Signed Android App Bundle (.aab)
```

Prepare the application for Google Play submission.

---

# 42. Coding Agent Instructions

You are working as a senior Flutter engineer.

Before writing code:

1. Inspect the existing environment.
2. Check Flutter/Dart/Android/JDK versions.
3. Check connected devices.
4. Inspect the project directory.
5. Do not overwrite existing work unnecessarily.

Then:

1. Explain the current environment briefly.
2. Explain the proposed project structure.
3. Explain dependencies.
4. Explain the implementation plan.
5. Implement only the requested development step.
6. Run Flutter analyzer.
7. Run tests where applicable.
8. Fix errors.
9. Verify the application builds.

Do NOT generate hundreds of files blindly.

Do NOT implement the entire application in one step.

Build Journiq incrementally.

After completing each major step, verify it before moving to the next step.

---

# 43. Important Engineering Rules

Follow these rules throughout the project:

* Keep business logic outside widgets.
* Prefer small, testable classes.
* Avoid unnecessary dependencies.
* Use null safety properly.
* Use meaningful names.
* Keep code readable.
* Avoid duplicated logic.
* Handle errors explicitly.
* Avoid memory leaks.
* Dispose streams/controllers correctly.
* Avoid excessive database writes.
* Avoid excessive network calls.
* Keep GPS tracking battery-conscious.
* Keep the UI responsive.
* Do not block the main isolate with expensive work.
* Do not hardcode secrets.
* Do not use fake production data.

---

# 44. Product Goal

The final V1 should feel like a real application.

A user should be able to install Journiq on an Android phone and realistically use it to track their daily journeys.

The core experience should be:

```text
Open Journiq
      ↓
See weather + statistics
      ↓
Start Journey
      ↓
Select Journey Mode
      ↓
GPS starts
      ↓
Live map shows current position
      ↓
Route is drawn
      ↓
Distance / Duration / Speed update
      ↓
Pause / Resume if necessary
      ↓
Stop Journey
      ↓
Journey Summary
      ↓
Weather + Areas Covered + Route
      ↓
Journey saved locally
      ↓
View History
      ↓
View Statistics
      ↓
View My Journey Map
```

### Final Product Identity

**Journiq**

**Track Every Journey.**

The application should be simple enough for everyday use, technically well-structured enough for future backend integration, and polished enough to serve as a genuine Google Play Store project.
