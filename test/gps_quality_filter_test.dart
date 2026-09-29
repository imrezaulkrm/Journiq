import 'package:flutter_test/flutter_test.dart';
import 'package:journiq/features/journey/domain/models/journey_mode.dart';
import 'package:journiq/features/journey/domain/models/tracking_point.dart';
import 'package:journiq/features/journey/domain/services/gps_quality_filter.dart';

TrackingPoint makePoint({
  required double lat,
  required double lng,
  required int secondOffset,
  double accuracy = 8.0,
  double speedKmh = 0.0,
  DateTime? baseTime,
}) {
  final base = baseTime ?? DateTime(2026, 9, 29, 10, 0, 0);
  return TrackingPoint(
    latitude: lat,
    longitude: lng,
    timestamp: base.add(Duration(seconds: secondOffset)),
    accuracyMeters: accuracy,
    speedKmh: speedKmh,
  );
}

void main() {
  final baseTime = DateTime(2026, 9, 29, 10, 0, 0);

  group('GPS Quality Filter', () {
    test('accepts valid initial sample and normal movement', () {
      final initial = makePoint(lat: 23.8103, lng: 90.4125, secondOffset: 0, baseTime: baseTime);
      final filter = GpsQualityFilter(JourneyMode.walking, initial);

      expect(filter.lastValidPoint, isNotNull);
      expect(filter.lastValidPoint!.latitude, 23.8103);

      // Advance by ~10 meters in 3 seconds (~12 km/h jogging)
      final candidate = makePoint(lat: 23.81039, lng: 90.4125, secondOffset: 3, baseTime: baseTime);
      final result = filter.evaluate(candidate, now: baseTime.add(const Duration(seconds: 3)));

      expect(result, GpsFilterResult.accepted);
      expect(filter.lastValidPoint!.latitude, 23.81039);
      expect(filter.lastValidPoint!.speedKmh, greaterThan(0));
    });

    test('rejects invalid coordinates (out of range, NaN, infinite)', () {
      final filter = GpsQualityFilter(JourneyMode.walking);

      final outOfRangeLat = makePoint(lat: 95.0, lng: 90.0, secondOffset: 0, baseTime: baseTime);
      expect(filter.evaluate(outOfRangeLat, now: baseTime), GpsFilterResult.rejectedCoordinates);

      final outOfRangeLng = makePoint(lat: 23.0, lng: 190.0, secondOffset: 0, baseTime: baseTime);
      expect(filter.evaluate(outOfRangeLng, now: baseTime), GpsFilterResult.rejectedCoordinates);

      final nanLat = makePoint(lat: double.nan, lng: 90.0, secondOffset: 0, baseTime: baseTime);
      expect(filter.evaluate(nanLat, now: baseTime), GpsFilterResult.rejectedCoordinates);

      final infLng = makePoint(lat: 23.0, lng: double.infinity, secondOffset: 0, baseTime: baseTime);
      expect(filter.evaluate(infLng, now: baseTime), GpsFilterResult.rejectedCoordinates);
    });

    test('rejects poor accuracy exceeding maxAccuracyMeters', () {
      final filter = GpsQualityFilter(JourneyMode.walking);

      final poor = makePoint(lat: 23.8103, lng: 90.4125, secondOffset: 0, accuracy: 35.0, baseTime: baseTime);
      expect(filter.evaluate(poor, now: baseTime), GpsFilterResult.rejectedAccuracy);

      final negative = makePoint(lat: 23.8103, lng: 90.4125, secondOffset: 0, accuracy: -1.0, baseTime: baseTime);
      expect(filter.evaluate(negative, now: baseTime), GpsFilterResult.rejectedAccuracy);
    });

    test('rejects stale timestamp and future timestamp', () {
      final filter = GpsQualityFilter(JourneyMode.walking);

      // 30 seconds old
      final stale = makePoint(lat: 23.8103, lng: 90.4125, secondOffset: 0, baseTime: baseTime);
      expect(
        filter.evaluate(stale, now: baseTime.add(const Duration(seconds: 30))),
        GpsFilterResult.rejectedTimestampStale,
      );

      // 10 seconds into the future
      final future = makePoint(lat: 23.8103, lng: 90.4125, secondOffset: 10, baseTime: baseTime);
      expect(
        filter.evaluate(future, now: baseTime),
        GpsFilterResult.rejectedTimestampFuture,
      );
    });

    test('rejects duplicate positions and too frequent samples', () {
      final initial = makePoint(lat: 23.8103, lng: 90.4125, secondOffset: 0, baseTime: baseTime);
      final filter = GpsQualityFilter(JourneyMode.walking, initial);

      // Exact same coordinates
      final duplicateCoords = makePoint(lat: 23.8103, lng: 90.4125, secondOffset: 2, baseTime: baseTime);
      expect(
        filter.evaluate(duplicateCoords, now: baseTime.add(const Duration(seconds: 2))),
        GpsFilterResult.rejectedDuplicate,
      );

      // Time interval <= 0.2s
      final tooFast = makePoint(lat: 23.8104, lng: 90.4125, secondOffset: 0, baseTime: baseTime);
      expect(
        filter.evaluate(tooFast, now: baseTime),
        GpsFilterResult.rejectedDuplicate,
      );
    });

    test('filters stationary dwell jitter and converges speed to 0', () {
      final initial = makePoint(lat: 23.8103, lng: 90.4125, secondOffset: 0, baseTime: baseTime);
      final filter = GpsQualityFilter(JourneyMode.walking, initial);

      // Tiny drift under 1 meter
      for (var i = 1; i <= 5; i++) {
        final jitter = makePoint(
          lat: 23.8103 + (0.000005 * i),
          lng: 90.4125,
          secondOffset: i,
          speedKmh: 0.2,
          baseTime: baseTime,
        );
        final result = filter.evaluate(jitter, now: baseTime.add(Duration(seconds: i)));
        expect(result, GpsFilterResult.rejectedDwellJitter);
      }

      // Anchor point speed is 0 and coordinates stayed at initial
      expect(filter.lastValidPoint!.speedKmh, equals(0.0));
      expect(filter.lastValidPoint!.latitude, equals(23.8103));
    });

    test('mode-specific speed limits reject impossible jumps', () {
      final initial = makePoint(lat: 23.8103, lng: 90.4125, secondOffset: 0, baseTime: baseTime);

      // In Walking mode, 50 km/h jump is rejected
      final walkingFilter = GpsQualityFilter(JourneyMode.walking, initial);
      // 50m in 1 second = 180 km/h
      final spike = makePoint(lat: 23.81075, lng: 90.4125, secondOffset: 1, baseTime: baseTime);
      expect(
        walkingFilter.evaluate(spike, now: baseTime.add(const Duration(seconds: 1))),
        GpsFilterResult.rejectedSpeedSpike,
      );

      // In Car mode, 60 km/h (16.6 m/s) is accepted
      final carFilter = GpsQualityFilter(JourneyMode.car, initial);
      // ~16 meters in 1 second = 58 km/h
      final carMove = makePoint(lat: 23.810444, lng: 90.4125, secondOffset: 1, baseTime: baseTime);
      expect(
        carFilter.evaluate(carMove, now: baseTime.add(const Duration(seconds: 1))),
        GpsFilterResult.accepted,
      );
    });
  });
}
