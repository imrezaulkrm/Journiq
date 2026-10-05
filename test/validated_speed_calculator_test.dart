import 'package:flutter_test/flutter_test.dart';
import 'package:journiq/features/journey/domain/models/journey_mode.dart';
import 'package:journiq/features/journey/domain/models/tracking_point.dart';
import 'package:journiq/features/journey/domain/services/gps_quality_filter.dart';

TrackingPoint point(double lat, int seconds, {double accuracy = 5}) =>
    TrackingPoint(
      latitude: lat,
      longitude: 90,
      timestamp: DateTime(2024, 1, 1).add(Duration(seconds: seconds)),
      speedKmh: 999,
      accuracyMeters: accuracy,
    );

void main() {
  test('derives speed from distance, not device speed, and smooths spikes', () {
    final filter = GpsQualityFilter(JourneyMode.walking, point(23.0, 0));
    expect(
      filter.evaluate(point(23.00002, 1), now: DateTime(2024, 1, 1, 0, 0, 1)),
      GpsFilterResult.accepted,
    );
    final first = filter.lastValidPoint!.speedKmh;
    expect(first, greaterThan(0));
    expect(first, lessThan(22));
  });

  test('rejects stale, out of order, inaccurate and impossible points', () {
    final filter = GpsQualityFilter(JourneyMode.car, point(23, 0));
    expect(
      filter.evaluate(point(23.0001, -20), now: DateTime(2024, 1, 1)),
      GpsFilterResult.rejectedTimestampStale,
    );
    expect(
      filter.evaluate(point(23.0001, 0), now: DateTime(2024, 1, 1)),
      GpsFilterResult.rejectedDuplicate,
    );
    expect(
      filter.evaluate(
        point(23.0001, 1, accuracy: 40),
        now: DateTime(2024, 1, 1, 0, 0, 1),
      ),
      GpsFilterResult.rejectedAccuracy,
    );
    expect(
      filter.evaluate(point(24, 1), now: DateTime(2024, 1, 1, 0, 0, 1)),
      GpsFilterResult.rejectedSpeedSpike,
    );
  });

  test('stationary jitter converges to zero', () {
    final filter = GpsQualityFilter(JourneyMode.walking, point(23, 0));
    for (var i = 1; i <= 4; i++) {
      filter.evaluate(
        point(23.000001 * i + 23, i),
        now: DateTime(2024, 1, 1, 0, 0, i),
      );
    }
    expect(filter.lastValidPoint!.speedKmh, equals(0));
  });
}
