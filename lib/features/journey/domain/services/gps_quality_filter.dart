import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/distance_calculator.dart';
import '../models/journey_mode.dart';
import '../models/tracking_point.dart';
import 'validated_speed_calculator.dart';

enum GpsFilterResult {
  accepted,
  rejectedCoordinates,
  rejectedAccuracy,
  rejectedTimestampStale,
  rejectedTimestampFuture,
  rejectedDuplicate,
  rejectedSpeedSpike,
  rejectedDwellJitter,
}

class GpsQualityFilter {
  final JourneyMode mode;
  TrackingPoint? _lastValidPoint;
  late final ValidatedSpeedCalculator _speedCalculator = ValidatedSpeedCalculator(mode);

  GpsQualityFilter(this.mode, [TrackingPoint? initialPoint])
      : _lastValidPoint = initialPoint == null
            ? null
            : TrackingPoint(
                latitude: initialPoint.latitude,
                longitude: initialPoint.longitude,
                timestamp: initialPoint.timestamp,
                speedKmh: 0,
                accuracyMeters: initialPoint.accuracyMeters,
                heading: initialPoint.heading,
              );

  TrackingPoint? get lastValidPoint => _lastValidPoint;

  void reset([TrackingPoint? lastPoint]) {
    _lastValidPoint = lastPoint;
    _speedCalculator.reset();
  }

  /// Evaluates an incoming candidate point against the multi-stage filter pipeline.
  /// Returns [GpsFilterResult.accepted] if point meets all quality criteria.
  GpsFilterResult evaluate(TrackingPoint candidate, {DateTime? now}) {
    final currentTime = now ?? DateTime.now();

    // 1. Coordinate Validity
    if (!candidate.latitude.isFinite ||
        !candidate.longitude.isFinite ||
        candidate.latitude.isNaN ||
        candidate.longitude.isNaN ||
        candidate.latitude < -90.0 ||
        candidate.latitude > 90.0 ||
        candidate.longitude < -180.0 ||
        candidate.longitude > 180.0) {
      return GpsFilterResult.rejectedCoordinates;
    }

    // 2. Accuracy Validation
    if (candidate.accuracyMeters <= 0 ||
        candidate.accuracyMeters > AppConstants.maxAccuracyMeters) {
      return GpsFilterResult.rejectedAccuracy;
    }

    // 3. Timestamp Validation (Freshness and Future checks)
    final ageSeconds = currentTime.difference(candidate.timestamp).inMilliseconds / 1000.0;
    if (ageSeconds > AppConstants.maxTimestampAgeSeconds) {
      return GpsFilterResult.rejectedTimestampStale;
    }
    if (candidate.timestamp.difference(currentTime).inMilliseconds / 1000.0 > AppConstants.maxFutureTimestampSeconds) {
      return GpsFilterResult.rejectedTimestampFuture;
    }

    // If this is the initial point, accept it as the baseline anchor
    if (_lastValidPoint == null) {
      _lastValidPoint = candidate;
      return GpsFilterResult.accepted;
    }

    final prev = _lastValidPoint!;

    // 4. Duplicate Coordinate Detection
    if (prev.latitude == candidate.latitude &&
        prev.longitude == candidate.longitude) {
      return GpsFilterResult.rejectedDuplicate;
    }

    // 5. Movement Distance and Time Delta
    final distanceMeters = DistanceCalculator.haversineDistanceMeters(
      prev.latitude,
      prev.longitude,
      candidate.latitude,
      candidate.longitude,
    );

    final timeDeltaMillis = candidate.timestamp.difference(prev.timestamp).inMilliseconds;
    final timeDeltaSeconds = timeDeltaMillis / 1000.0;

    // Reject out-of-order or duplicate timestamp points
    if (timeDeltaSeconds <= AppConstants.minSampleIntervalSeconds) {
      return GpsFilterResult.rejectedDuplicate;
    }

    final calculatedSpeedKmh = (distanceMeters / timeDeltaSeconds) * 3.6;

    // 6. Stationary Dwell / Jitter Filter
    // Small movement (< 3m) with near-zero speed represents GPS drift while stationary.
    if (distanceMeters < AppConstants.minMovementMeters &&
        (candidate.speedKmh < AppConstants.maxAllowedDwellSpeedKmh ||
            calculatedSpeedKmh < AppConstants.maxAllowedDwellSpeedKmh)) {
      _speedCalculator.decayStationary();
      // Keep geographic anchor stable while decaying speed and advancing timestamp
      _lastValidPoint = TrackingPoint(
        latitude: prev.latitude,
        longitude: prev.longitude,
        timestamp: candidate.timestamp,
        speedKmh: _speedCalculator.lastSpeedKmh,
        accuracyMeters: candidate.accuracyMeters,
        heading: prev.heading,
      );
      return GpsFilterResult.rejectedDwellJitter;
    }

    // 7. Mode-aware Speed Sanity Check (Jump filtering)
    if (calculatedSpeedKmh > mode.maxPlausibleSpeedKmh) {
      return GpsFilterResult.rejectedSpeedSpike;
    }

    // Point passed all checks!
    final validatedSpeed = _speedCalculator.calculate(previous: prev, current: candidate);
    _lastValidPoint = TrackingPoint(
      latitude: candidate.latitude,
      longitude: candidate.longitude,
      timestamp: candidate.timestamp,
      speedKmh: validatedSpeed,
      accuracyMeters: candidate.accuracyMeters,
      heading: candidate.heading,
    );
    return GpsFilterResult.accepted;
  }
}
