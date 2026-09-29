import 'dart:async';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/utils/distance_calculator.dart';
import '../../../../database/app_database.dart';
import '../../geocoding/data/geocoding_service.dart';
import '../../geocoding/domain/areas_extractor.dart';
import '../../weather/data/weather_service.dart';
import '../../weather/domain/models/weather_snapshot.dart';
import '../data/repositories/journey_repository.dart';
import '../data/services/location_service.dart';
import '../domain/models/journey_mode.dart';
import '../domain/models/tracking_metrics.dart';
import '../domain/models/tracking_point.dart';
import '../domain/models/tracking_state.dart';
import '../domain/services/gps_quality_filter.dart';

// Database & Service Providers
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final journeyRepositoryProvider = Provider<JourneyRepository>((ref) {
  return DriftJourneyRepository(ref.watch(databaseProvider));
});

final locationServiceProvider = Provider<ILocationService>((ref) {
  return GeolocatorLocationService();
});

final weatherServiceProvider = Provider<IWeatherService>((ref) {
  return OpenMeteoWeatherService();
});

final geocodingServiceProvider = Provider<IGeocodingService>((ref) {
  return NominatimGeocodingService();
});

final trackingProvider = StateNotifierProvider<TrackingNotifier, TrackingMetrics>((ref) {
  return TrackingNotifier(
    locationService: ref.watch(locationServiceProvider),
    repository: ref.watch(journeyRepositoryProvider),
    weatherService: ref.watch(weatherServiceProvider),
    geocodingService: ref.watch(geocodingServiceProvider),
  );
});

class TrackingNotifier extends StateNotifier<TrackingMetrics> {
  final ILocationService _locationService;
  final JourneyRepository _repository;
  final IWeatherService _weatherService;
  final IGeocodingService _geocodingService;

  StreamSubscription<TrackingPoint>? _gpsSubscription;
  Timer? _tickerTimer;
  GpsQualityFilter? _filter;

  DateTime? _journeyStartTime;
  DateTime? _pausedTime;
  bool _justResumed = false;

  final List<TrackingPoint> _unpersistedPoints = [];

  TrackingNotifier({
    required ILocationService locationService,
    required JourneyRepository repository,
    required IWeatherService weatherService,
    required IGeocodingService geocodingService,
  })  : _locationService = locationService,
        _repository = repository,
        _weatherService = weatherService,
        _geocodingService = geocodingService,
        super(const TrackingMetrics());

  /// Check and restore any unfinished active journey on app launch
  Future<ActiveJourney?> checkActiveRecovery() async {
    try {
      final active = await _repository.getActiveJourney();
      if (active != null) {
        final recoveredPoints = await _repository.getPointsForJourney(active.id);
        final mode = JourneyModeX.fromIndex(active.mode);

        _journeyStartTime = active.startTime;
        _filter = GpsQualityFilter(mode, recoveredPoints.isNotEmpty ? recoveredPoints.last : null);

        state = TrackingMetrics(
          journeyId: active.id,
          mode: mode,
          status: active.isPaused ? TrackingStatus.paused : TrackingStatus.tracking,
          distanceMeters: active.distanceMeters,
          activeDurationSeconds: active.activeDurationSeconds,
          maxSpeedKmh: active.maxSpeedKmh,
          currentPoint: recoveredPoints.isNotEmpty ? recoveredPoints.last : null,
          points: recoveredPoints,
        );

        if (!active.isPaused) {
          _startTicker();
          _startGpsStream(active.id, mode);
        }
        return active;
      }
    } catch (_) {}
    return null;
  }

  /// Discard active journey during recovery dialog
  Future<void> discardActiveJourney(String id) async {
    await _repository.clearActiveJourney(id);
    await _repository.deleteJourney(id);
    state = const TrackingMetrics();
  }

  /// Start a new journey
  Future<bool> startJourney(JourneyMode mode) async {
    state = state.copyWith(status: TrackingStatus.starting, mode: mode);

    // 1. Verify Location Service
    final isServiceEnabled = await _locationService.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      state = state.copyWith(
        status: TrackingStatus.error,
        errorMessage: 'Location services are disabled. Please enable GPS to start tracking.',
      );
      return false;
    }

    // 2. Verify Permissions
    var permission = await _locationService.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _locationService.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      state = state.copyWith(
        status: TrackingStatus.error,
        errorMessage: 'Location permission required. Please allow location access.',
      );
      return false;
    }

    state = state.copyWith(status: TrackingStatus.waitingForGps);

    // 3. Acquire initial position
    TrackingPoint initialPoint;
    try {
      initialPoint = await _locationService.getCurrentPosition();
    } catch (_) {
      state = state.copyWith(
        status: TrackingStatus.error,
        errorMessage: 'GPS fix unavailable. Move outdoors and try again.',
      );
      return false;
    }

    final journeyId = DateTime.now().microsecondsSinceEpoch.toString();
    _journeyStartTime = DateTime.now();
    _pausedTime = null;
    _justResumed = false;
    _filter = GpsQualityFilter(mode, initialPoint);

    // 4. Initialize State
    state = TrackingMetrics(
      journeyId: journeyId,
      mode: mode,
      status: TrackingStatus.tracking,
      distanceMeters: 0.0,
      activeDurationSeconds: 0,
      currentSpeedKmh: 0.0,
      averageSpeedKmh: 0.0,
      maxSpeedKmh: 0.0,
      gpsAccuracyMeters: initialPoint.accuracyMeters,
      heading: initialPoint.heading,
      currentPoint: initialPoint,
      points: [initialPoint],
    );

    // 5. Save active recovery entry in SQLite
    await _repository.saveActiveJourney(
      ActiveJourneysCompanion(
        id: drift.Value(journeyId),
        mode: drift.Value(mode.index),
        startTime: drift.Value(_journeyStartTime!),
        activeDurationSeconds: const drift.Value(0),
        distanceMeters: const drift.Value(0.0),
        maxSpeedKmh: drift.Value(initialPoint.speedKmh),
        isPaused: const drift.Value(false),
        lastUpdated: drift.Value(DateTime.now()),
      ),
    );
    await _repository.createJourneyDraft(
      id: journeyId,
      mode: mode,
      startTime: _journeyStartTime!,
    );

    _unpersistedPoints.add(initialPoint);
    await _persistPointsBatch(journeyId);

    // 6. Start Ticker and GPS stream
    _startTicker();
    _startGpsStream(journeyId, mode);

    return true;
  }

  void _startTicker() {
    _tickerTimer?.cancel();
    _tickerTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.status == TrackingStatus.tracking) {
        final newActiveSeconds = state.activeDurationSeconds + 1;
        final avgSpeed = newActiveSeconds > 0
            ? (state.distanceMeters / newActiveSeconds) * 3.6
            : 0.0;

        // Smoothly decay live speed to 0 if stationary or no recent movement fixes
        var currentSpeed = state.currentSpeedKmh;
        if (_filter?.lastValidPoint != null) {
          final secondsSinceLastPoint =
              DateTime.now().difference(_filter!.lastValidPoint!.timestamp).inSeconds;
          if (secondsSinceLastPoint >= 3 && currentSpeed > 0) {
            currentSpeed *= 0.4;
            if (currentSpeed < 0.2) currentSpeed = 0.0;
          }
        }

        state = state.copyWith(
          activeDurationSeconds: newActiveSeconds,
          averageSpeedKmh: avgSpeed,
          currentSpeedKmh: currentSpeed,
        );

        // Update active journey metadata in SQLite every 10 seconds
        if (newActiveSeconds % 10 == 0 && state.journeyId != null) {
          _repository.saveActiveJourney(
            ActiveJourneysCompanion(
              id: drift.Value(state.journeyId!),
              mode: drift.Value(state.mode.index),
              startTime: drift.Value(_journeyStartTime ?? DateTime.now()),
              activeDurationSeconds: drift.Value(newActiveSeconds),
              distanceMeters: drift.Value(state.distanceMeters),
              maxSpeedKmh: drift.Value(state.maxSpeedKmh),
              isPaused: const drift.Value(false),
              lastUpdated: drift.Value(DateTime.now()),
            ),
          );
        }
      }
    });
  }

  void _startGpsStream(String journeyId, JourneyMode mode) {
    _gpsSubscription?.cancel();

    _gpsSubscription = _locationService.getPositionStream(
      notificationTitle: 'Journiq • ${mode.label} in Progress',
      notificationText: 'Tracking your route in background',
    ).listen(
      (candidate) => _handleGpsCandidate(candidate, journeyId),
      onError: (err) {
        // GPS errors should not crash the session
      },
    );
  }

  Future<void> _handleGpsCandidate(TrackingPoint candidate, String journeyId) async {
    if (state.status != TrackingStatus.tracking || _filter == null) return;

    if (_justResumed) {
      _justResumed = false;
      // Re-anchor to the post-resume location without adding pause jump distance or distorted speed
      _filter!.reset(candidate);
      state = state.copyWith(
        currentPoint: candidate,
        currentSpeedKmh: 0.0,
      );
      return;
    }

    final filterResult = _filter!.evaluate(candidate);
    if (filterResult == GpsFilterResult.rejectedDwellJitter) {
      // User is stationary or in GPS jitter: decay live speed toward 0
      state = state.copyWith(
        currentSpeedKmh: _filter!.lastValidPoint?.speedKmh ?? 0.0,
      );
      return;
    }

    if (filterResult != GpsFilterResult.accepted) {
      return;
    }

    // Incremental distance calculation from last accepted point
    final acceptedPoint = _filter!.lastValidPoint!;
    double incrementalDistance = 0.0;
    if (state.currentPoint != null) {
      incrementalDistance = DistanceCalculator.haversineDistanceMeters(
        state.currentPoint!.latitude,
        state.currentPoint!.longitude,
        acceptedPoint.latitude,
        acceptedPoint.longitude,
      );
    }

    final newTotalDistance = state.distanceMeters + incrementalDistance;
    final newMaxSpeed = acceptedPoint.speedKmh > state.maxSpeedKmh
        ? acceptedPoint.speedKmh
        : state.maxSpeedKmh;

    final updatedPoints = List<TrackingPoint>.of(state.points)..add(acceptedPoint);
    _unpersistedPoints.add(acceptedPoint);

    state = state.copyWith(
      distanceMeters: newTotalDistance,
      currentSpeedKmh: acceptedPoint.speedKmh,
      maxSpeedKmh: newMaxSpeed,
      gpsAccuracyMeters: acceptedPoint.accuracyMeters,
      heading: acceptedPoint.heading ?? state.heading,
      currentPoint: acceptedPoint,
      points: updatedPoints,
    );

    // Progressive batch insert every 10 points
    if (_unpersistedPoints.length >= 10) {
      await _persistPointsBatch(journeyId);
    }
  }

  Future<void> _persistPointsBatch(String journeyId) async {
    if (_unpersistedPoints.isEmpty) return;
    final batchToSave = List<TrackingPoint>.of(_unpersistedPoints);
    _unpersistedPoints.clear();
    await _repository.insertPointsBatch(journeyId, batchToSave);
  }

  /// Pause tracking
  void pauseJourney() {
    if (state.status == TrackingStatus.tracking) {
      _pausedTime = DateTime.now();
      state = state.copyWith(status: TrackingStatus.paused);

      if (state.journeyId != null) {
        _repository.saveActiveJourney(
          ActiveJourneysCompanion(
            id: drift.Value(state.journeyId!),
            mode: drift.Value(state.mode.index),
            startTime: drift.Value(_journeyStartTime ?? DateTime.now()),
            activeDurationSeconds: drift.Value(state.activeDurationSeconds),
            distanceMeters: drift.Value(state.distanceMeters),
            maxSpeedKmh: drift.Value(state.maxSpeedKmh),
            isPaused: const drift.Value(true),
            pausedAt: drift.Value(_pausedTime),
            lastUpdated: drift.Value(DateTime.now()),
          ),
        );
      }
    }
  }

  /// Resume tracking
  void resumeJourney() {
    if (state.status == TrackingStatus.paused) {
      _pausedTime = null;
      _justResumed = true;
      state = state.copyWith(status: TrackingStatus.tracking);

      if (state.journeyId != null) {
        _repository.saveActiveJourney(
          ActiveJourneysCompanion(
            id: drift.Value(state.journeyId!),
            mode: drift.Value(state.mode.index),
            startTime: drift.Value(_journeyStartTime ?? DateTime.now()),
            activeDurationSeconds: drift.Value(state.activeDurationSeconds),
            distanceMeters: drift.Value(state.distanceMeters),
            maxSpeedKmh: drift.Value(state.maxSpeedKmh),
            isPaused: const drift.Value(false),
            lastUpdated: drift.Value(DateTime.now()),
          ),
        );
      }
    }
  }

  /// Finalize and save the journey transactionally
  Future<String?> stopAndSaveJourney() async {
    final journeyId = state.journeyId;
    if (journeyId == null) return null;

    state = state.copyWith(status: TrackingStatus.saving);

    // 1. Cancel timers and subscriptions
    _tickerTimer?.cancel();
    await _gpsSubscription?.cancel();

    // 2. Persist any remaining points in buffer
    await _persistPointsBatch(journeyId);

    // 3. Obtain Weather snapshot
    WeatherSnapshot? weather;
    if (state.points.isNotEmpty) {
      final endPt = state.points.last;
      try {
        weather = await _weatherService.getWeather(endPt.latitude, endPt.longitude);
      } catch (_) {
        weather = null;
      }
    }

    // 4. Extract Areas Covered
    List<String> areas = [];
    try {
      final extractor = AreasCoveredExtractor(_geocodingService);
      areas = await extractor.extractAreas(state.points);
    } catch (_) {}

    // 5. Transactional Save to SQLite
    final endTime = DateTime.now();
    final startPt = state.points.isNotEmpty ? state.points.first : null;
    final endPt = state.points.isNotEmpty ? state.points.last : null;

    await _repository.saveCompleteJourney(
      id: journeyId,
      mode: state.mode,
      startTime: _journeyStartTime ?? endTime,
      endTime: endTime,
      activeDurationSeconds: state.activeDurationSeconds,
      distanceMeters: state.distanceMeters,
      averageSpeedKmh: state.averageSpeedKmh,
      maxSpeedKmh: state.maxSpeedKmh,
      points: state.points,
      startLatitude: startPt?.latitude,
      startLongitude: startPt?.longitude,
      endLatitude: endPt?.latitude,
      endLongitude: endPt?.longitude,
      weatherTemperature: weather?.temperature,
      weatherCondition: weather?.condition,
      weatherHumidity: weather?.humidity,
      weatherWindSpeed: weather?.windSpeedKmh,
      weatherRainProbability: weather?.rainProbability,
      weatherObservedAt: weather?.observedAt,
      areasCovered: areas,
    );

    state = state.copyWith(status: TrackingStatus.completed);
    return journeyId;
  }

  void reset() {
    _tickerTimer?.cancel();
    _gpsSubscription?.cancel();
    state = const TrackingMetrics();
  }

  @override
  void dispose() {
    _tickerTimer?.cancel();
    _gpsSubscription?.cancel();
    super.dispose();
  }
}
